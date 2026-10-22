// IDE tab: edit the firmware, build it, run the real fw.bin on the simulated board.
(() => {
  const $ = s => document.querySelector(s);
  let editor = null, cur = null, sim = null, raf = 0, t0 = 0, simKeys = 0, audio = null, saveTimer = 0;
  let mode = 'rtl', rtlRunning = false;

  // ---------------------------------------------------------------- editor
  require.config({ paths: { vs: '../node_modules/monaco-editor/min/vs' } });
  require(['vs/editor/editor.main'], () => {
    monaco.editor.defineTheme('pocket', { base: 'vs-dark', inherit: true, rules: [], colors: { 'editor.background': '#0b0b0b', 'editor.lineHighlightBackground': '#161616' } });
    editor = monaco.editor.create($('#editor'), {
      theme: 'pocket', automaticLayout: true, fontSize: 13, minimap: { enabled: false },
      fontFamily: 'Cascadia Mono, Consolas, monospace', scrollBeyondLastLine: false,
    });
    editor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS, save);
    editor.addCommand(monaco.KeyCode.F5, () => buildAndRun());
    loadFiles();
  });

  async function loadFiles() {
    const files = await S.ideFiles();
    const box = $('#files');
    box.innerHTML = '';
    for (const f of files) {
      const d = document.createElement('div');
      d.textContent = f.name;
      d.onclick = () => open(f, d);
      box.append(d);
      if (!cur && f.name === 'src/main.c') open(f, d);
    }
  }
  async function open(f, el) {
    if (cur && cur.dirty && !confirm('Discard changes to ' + cur.name + '?')) return;
    const text = await S.ideRead(f.path);
    const lang = /\.(c|h)$/.test(f.name) ? 'c' : /\.py$/.test(f.name) ? 'python' : /\.sh$/.test(f.name) ? 'shell' : 'plaintext';
    editor.setModel(monaco.editor.createModel(text, lang));
    cur = { ...f, dirty: false };
    editor.getModel().onDidChangeContent(() => { cur.dirty = true; $('#fname').textContent = cur.name + ' •'; });
    $('#fname').textContent = cur.name;
    document.querySelectorAll('#files div').forEach(x => x.classList.toggle('on', x === el));
  }
  async function save() {
    if (!cur) return;
    await S.ideWrite(cur.path, editor.getValue());
    cur.dirty = false;
    $('#fname').textContent = cur.name;
  }

  // ---------------------------------------------------------------- build
  const blog = $('#buildlog');
  S.on('build-log', t => { blog.textContent += t; blog.scrollTop = blog.scrollHeight; });
  async function build() {
    if (cur && cur.dirty) await save();
    blog.textContent = '$ fw/build.sh\n';
    $('#build').disabled = true;
    const code = await S.ideBuild();
    $('#build').disabled = false;
    blog.textContent += code === 0 ? '\nbuild ok\n' : `\nbuild failed (${code})\n`;
    blog.scrollTop = blog.scrollHeight;
    return code === 0;
  }
  async function buildAndRun() { if (await build()) start(true); }
  $('#save').onclick = save;
  $('#build').onclick = build;
  $('#run').onclick = () => start(true);
  $('#flashfw').onclick = async () => { if (await build()) { S.installBuild('firmware'); document.querySelector('.tab[data-tab="install"]').click(); } };

  // ---------------------------------------------------------------- simulator
  const slog = $('#simlog');
  let uartLine = '';
  function uart(c) {
    uartLine += c;
    if (c === '\n') {
      if (!/^[0-9a-f]{64,84}\n$/.test(uartLine) && !/^(LCD|OSD)-/.test(uartLine)) {
        slog.textContent += uartLine;
        if (slog.textContent.length > 30000) slog.textContent = slog.textContent.slice(-20000);
        slog.scrollTop = slog.scrollHeight;
      }
      uartLine = '';
    }
  }
  function beep(v) {
    const hp = v & 0xfff, ms = (v >>> 16) & 0xfff;
    if (!ms) return;
    audio = audio || new AudioContext();
    const o = audio.createOscillator(), g = audio.createGain();
    o.type = 'square';
    o.frequency.value = 1e6 / (8 * (hp + 1));
    g.gain.value = 0.04;
    o.connect(g).connect(audio.destination);
    o.start();
    o.stop(audio.currentTime + ms / 1000);
  }
  let coreState = 'reset';
  function core(state) { coreState = state; }

  async function start(freshFw) {
    stop();
    if (mode === 'rtl') return startRtl(freshFw);
    const { flash, sd } = await S.simLoad({ freshFw });
    slog.textContent = '';
    try {
      sim = new Sim(Board, RV32E, { flash, sd, onUart: uart, onBeep: beep, onCore: core });
    } catch (e) { slog.textContent = 'cannot start: ' + e.message + '\n'; return; }
    t0 = performance.now();
    $('#simstate').textContent = 'running';
    $('#simhdmi').focus();
    loop();
  }
  function stop() {
    if (rtlRunning) { S.rtlStop(); rtlRunning = false; }
    if (raf) cancelAnimationFrame(raf);
    raf = 0;
    if (sim) persist(true);
    sim = null;
  }
  function persist(force) {
    const b = sim && sim.board;
    if (!b) return;
    if (force || b.flash.dirty || b.sd.dirty) {
      S.simSave(b.flash.dirty || force ? b.flash.mem : null, b.sd.dirty || force ? b.sd.img : null);
      b.flash.dirty = b.sd.dirty = false;
    }
  }
  function loop() {
    raf = requestAnimationFrame(loop);
    try {
      sim.runUntil(performance.now() - t0);
    } catch (e) {
      slog.textContent += '\n*** ' + e.message + '\n';
      $('#simstate').textContent = 'stopped: ' + e.message;
      cancelAnimationFrame(raf); raf = 0;
      return;
    }
    sim.board.setKeys(simKeys);
    render();
    if (!saveTimer) saveTimer = setTimeout(() => { saveTimer = 0; persist(false); }, 1500);
  }
  $('#simreset').onclick = () => start(false);
  document.querySelectorAll('#simmode button').forEach(b => b.onclick = () => {
    document.querySelectorAll('#simmode button').forEach(x => x.classList.toggle('on', x === b));
    stop();
    mode = b.dataset.mode;
    $('#simstate').textContent = mode === 'rtl' ? 'Tang Nano 20K: the real RTL in Verilator (about 1/70 of real time)' : 'firmware only: fast, no Game Boy core';
  });
  $('#rtlbuild').onclick = async () => {
    blog.textContent = '$ sim/tang/build.sh\n';
    const code = await S.rtlBuild();
    blog.textContent += code === 0 ? '\nsimulator built\n' : `\nbuild failed (${code})\n`;
  };

  // ---- Tang Nano 20K: the Verilator model runs in its own process
  const hdmiFull = document.createElement('canvas');
  hdmiFull.width = 720; hdmiFull.height = 480;
  const hctx = hdmiFull.getContext('2d'), himgFull = hctx.createImageData(720, 480);
  async function startRtl(freshFw) {
    slog.textContent = '';
    const r = await S.rtlStart({ freshFw, noHdmi: !$('#simhdmion').checked });
    if (!r.ok) { $('#simstate').textContent = r.msg; return; }
    rtlRunning = true;
    hctx.clearRect(0, 0, 720, 480);
    hdmi.clearRect(0, 0, 672, 480);
    $('#simstate').textContent = 'Tang Nano 20K: starting (the boot takes about a minute of real time)';
    $('#simhdmi').focus();
  }
  S.on('rtl-log', t => { slog.textContent += t; slog.scrollTop = slog.scrollHeight; });
  S.on('rtl-time', ms => { if (rtlRunning) $('#simstate').textContent = `Tang Nano 20K · ${(ms / 1000).toFixed(2)} s simulated`; });
  S.on('rtl-exit', code => { if (rtlRunning) { rtlRunning = false; $('#simstate').textContent = 'simulator exited (' + code + ')'; } });
  // the picture arrives in bands of scanlines as they are drawn, only the ones that changed
  let hdmiDirty = false;
  S.on('rtl-band', b => {
    const y0 = b[0] | (b[1] << 8), rows = b[2] | (b[3] << 8), d = himgFull.data;
    for (let i = y0 * 720, j = 4, e = (y0 + rows) * 720; i < e; i++, j += 3) {
      d[i * 4] = b[j]; d[i * 4 + 1] = b[j + 1]; d[i * 4 + 2] = b[j + 2]; d[i * 4 + 3] = 255;
    }
    hctx.putImageData(himgFull, 0, 0, 0, y0, 720, rows);
    if (!hdmiDirty) { hdmiDirty = true; requestAnimationFrame(() => { hdmiDirty = false; hdmi.imageSmoothingEnabled = false; hdmi.drawImage(hdmiFull, 0, 0, 672, 480); }); }
  });
  $('#simhdmion').onchange = () => { if (rtlRunning) startRtl(false); };
  S.on('rtl-lcd', px => {
    const d = limg.data, v16 = new Uint16Array(px.buffer, px.byteOffset, 128 * 128);
    for (let i = 0; i < 128 * 128; i++) {
      const v = v16[i];
      d[i * 4] = ((v >> 11) & 31) * 255 / 31; d[i * 4 + 1] = ((v >> 5) & 63) * 255 / 63; d[i * 4 + 2] = (v & 31) * 255 / 31; d[i * 4 + 3] = 255;
    }
    lcd.putImageData(limg, 0, 0);
  });
  // REG_IN bits (keyboard map) -> the board buttons: up down left right a b select start, S1, S2
  function rtlBits(k) {
    return ((k & 16) ? 1 : 0) | ((k & 32) ? 2 : 0) | ((k & 64) ? 4 : 0) | ((k & 128) ? 8 : 0) | ((k & 256) ? 16 : 0) |
           ((k & 1) ? 32 : 0) | ((k & 4) ? 64 : 0) | ((k & 8) ? 128 : 0) | ((k & 4096) ? 256 : 0) | ((k & 8192) ? 512 : 0);
  }
  let lastRtl = -1;
  setInterval(() => { if (rtlRunning) { const b = rtlBits(simKeys); if (b !== lastRtl) { lastRtl = b; S.rtlKey(b); } } }, 30);
  $('#simsd').onclick = () => { if (sim) S.simSdOpen(sim.board.sd.img); };

  // ---------------------------------------------------------------- screens
  const hdmi = $('#simhdmi').getContext('2d'), lcd = $('#simlcd').getContext('2d');
  const himg = hdmi.createImageData(672, 480), limg = lcd.createImageData(128, 128);
  function cells(img, w, cellsArr, cols, rows, top, under) {
    const d = img.data;
    for (let cy = 0; cy < rows; cy++) for (let cx = 0; cx < cols; cx++) {
      const v = cellsArr[cy * cols + cx], attr = v >> 8, ch = v & 0xff, code = ch & 0x7f, ext = ch & 0x80;
      const fgi = attr & 15, bgi = attr >> 4;
      for (let py = 0; py < 10; py++) {
        const fy = py - 1;
        const bits = fy < 0 || fy > 7 ? (ext ? font[code * 8 + (fy < 0 ? 0 : 7)] : 0) : font[code * 8 + fy];
        for (let px = 0; px < 8; px++) {
          const on = (bits >> (7 - px)) & 1, ci = on ? fgi : bgi;
          const x = cx * 8 + px, y = top + cy * 10 + py, o = (y * w + x) * 4;
          let c;
          if (ci === 0) { if (!under) continue; c = under(x, y); } else c = PAL[ci];
          d[o] = c >> 16; d[o + 1] = (c >> 8) & 255; d[o + 2] = c & 255; d[o + 3] = 255;
        }
      }
    }
  }
  // the game layer: the core is not emulated; a dimmed placeholder with the cartridge title
  function gameLayer(img, w, h, dim) {
    const d = img.data, b = sim.board;
    for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) {
      const o = (y * w + x) * 4;
      let v = coreState === 'run' ? 24 + ((x >> 4) + (y >> 4) & 1) * 10 : 6;
      if (dim) v = v * 0.4;
      d[o] = d[o + 1] = d[o + 2] = v; d[o + 3] = 255;
    }
  }
  function render() {
    const b = sim.board, osdOn = b.ctrl & 0x20, dim = b.ctrl & 0x40;
    gameLayer(himg, 336, 240, dim);
    // the OSD is 42 x 24 cells of 8 x 10 here (16 x 20 on the real HDMI)
    const tmp = hdmi.createImageData(336, 240);
    tmp.data.set(himg.data.subarray(0, 336 * 240 * 4));
    if (osdOn) cells(tmp, 336, b.osd, 42, 24, 0, null);
    // scale 2x into the 672 x 480 canvas
    const d = himg.data, s = tmp.data;
    for (let y = 0; y < 480; y++) for (let x = 0; x < 672; x++) {
      const so = ((y >> 1) * 336 + (x >> 1)) * 4, o = (y * 672 + x) * 4;
      d[o] = s[so]; d[o + 1] = s[so + 1]; d[o + 2] = s[so + 2]; d[o + 3] = 255;
    }
    if (coreState === 'run' && !osdOn) title(himg);
    hdmi.putImageData(himg, 0, 0);
    gameLayer(limg, 128, 128, dim);
    if (osdOn) cells(limg, 128, b.lcd, 16, 12, 4, null);
    lcd.putImageData(limg, 0, 0);
    $('#simstate').textContent = `running · ${(b.vms / 1000).toFixed(1)} s · core ${coreState}`;
  }
  function title(img) {
    const b = sim.board;
    let t = '';
    for (let i = 0x134; i < 0x143; i++) { const c = b.sdram[i]; if (c < 32 || c > 126) break; t += String.fromCharCode(c); }
    const g = document.createElement('canvas').getContext('2d');
    void g;
    hdmi.putImageData(img, 0, 0);
    hdmi.fillStyle = '#7a7a7a';
    hdmi.font = '16px sans-serif';
    hdmi.textAlign = 'center';
    hdmi.fillText(`${t || 'game'} running (the core is not emulated)`, 336, 240);
    const cap = hdmi.getImageData(0, 0, 672, 480);
    img.data.set(cap.data);
  }

  // ---------------------------------------------------------------- keys
  const map = { ArrowUp: 16, ArrowDown: 32, ArrowLeft: 64, ArrowRight: 128, x: 256, X: 256, z: 1, Z: 1, Enter: 8, Backspace: 4, Escape: 4096, r: 8192, R: 8192 };
  for (const el of [$('#simhdmi'), $('#simlcd')]) {
    el.addEventListener('keydown', e => { const k = map[e.key]; if (k) { simKeys |= k; e.preventDefault(); } });
    el.addEventListener('keyup', e => { const k = map[e.key]; if (k) { simKeys &= ~k; e.preventDefault(); } });
    el.addEventListener('blur', () => { simKeys = 0; });
  }
  window.addEventListener('beforeunload', () => stop());
})();
