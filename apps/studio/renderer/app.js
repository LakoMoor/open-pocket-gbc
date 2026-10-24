// Open Pocket Studio, renderer.
const $ = s => document.querySelector(s);
const S = window.studio;
const kb = n => n >= 1048576 ? (n / 1048576).toFixed(1) + ' MB' : Math.round(n / 1024) + ' KB';
const ago = t => { const s = (Date.now() - t) / 1000; return s < 3600 ? Math.max(1, Math.round(s / 60)) + ' min ago' : s < 86400 ? Math.round(s / 3600) + ' h ago' : Math.round(s / 86400) + ' d ago'; };

// ---------------------------------------------------------------- tabs
document.querySelectorAll('.tab').forEach(t => t.onclick = () => {
  document.querySelectorAll('.tab').forEach(x => x.classList.toggle('on', x === t));
  document.querySelectorAll('.page').forEach(p => p.classList.toggle('on', p.id === 'p-' + t.dataset.tab));
});
function seg(el, fn) {
  el.querySelectorAll('button').forEach(b => b.onclick = () => {
    el.querySelectorAll('button').forEach(x => x.classList.toggle('on', x === b));
    fn(b.dataset.src);
  });
}

// ---------------------------------------------------------------- status
let st = { build: {}, drives: [] }, release = null, src = 'release', sdsrc = 'release';
const picked = {};
async function status() {
  st = await S.status();
  $('#dot').classList.toggle('on', !!st.port);
  $('#status').textContent = st.port ? `${st.connected ? 'connected' : 'board'} on ${st.port}` : 'board not found';
  renderInstall();
  renderDrives();
}
$('.badge').onclick = () => S.connect().then(status);

// ---------------------------------------------------------------- install
function item(label, value, onclick, primary, disabled) {
  const b = document.createElement('button');
  b.className = 'item' + (primary ? ' primary' : '');
  b.innerHTML = `<span></span><span class="v"></span>`;
  b.firstChild.textContent = label;
  b.lastChild.textContent = value || '';
  b.disabled = !!disabled;
  b.onclick = onclick;
  return b;
}
function renderInstall() {
  const l = $('#ilist');
  l.innerHTML = '';
  if (src === 'release') {
    const r = release;
    const v = !r ? 'checking…' : r.error ? (r.error.includes('404') ? 'no release published yet' : r.error) : `${r.tag} · ${new Date(r.published).toLocaleDateString()}`;
    l.append(item('Install the latest release', v, () => start(() => S.installRelease()), true, !r || r.error || !(r.fw || r.fpga)));
    l.append(item('Install Minimal (low power)', r && r.fpgaMin ? 'LCD, speaker, buttons; no HDMI, link port or LEDs' : 'not in this release',
      () => start(() => S.installRelease('min')), false, !r || r.error || !r.fpgaMin || !r.fw));
    if (r && !r.error) {
      l.append(item('Firmware', r.fw ? kb(r.fw.size) : 'not in the release', null, false, true));
      l.append(item('FPGA bitstream', r.fpga ? kb(r.fpga.size) : 'not in the release', null, false, true));
    }
  } else if (src === 'build') {
    const b = st.build, v = k => b[k] ? `${kb(b[k].size)} · ${ago(b[k].mtime)}` : 'not built';
    l.append(item('Update everything', 'bitstream + firmware', () => start(() => S.installBuild('all')), true, !b.bitstream || !b.firmware));
    l.append(item('Firmware', v('firmware'), () => start(() => S.installBuild('firmware')), false, !b.firmware));
    l.append(item('FPGA bitstream', v('bitstream'), () => start(() => S.installBuild('bitstream')), false, !b.bitstream));
    l.append(item('Game image', v('games'), () => start(() => S.installBuild('games')), false, !b.games));
    l.append(item('Try the bitstream until power off', 'SRAM', () => start(() => S.installBuild('sram')), false, !b.bitstream));
  } else {
    for (const [k, label] of [['bitstream', 'FPGA bitstream (.fs or .bin)'], ['firmware', 'Firmware (fw.bin)'], ['games', 'Game image (.bin)']]) {
      l.append(item(label, picked[k] ? picked[k].split(/[\\/]/).pop() : 'choose…', async () => {
        const f = await S.pick(k);
        if (f) { picked[k] = f; renderInstall(); }
      }));
    }
    const items = ['bitstream', 'firmware', 'games'].filter(k => picked[k]).map(k => ({ kind: k, file: picked[k] }));
    l.append(item('Install the chosen files', items.length ? items.length + ' file(s)' : '', () => start(() => S.install(items)), true, !items.length));
  }
}
seg($('#src'), s => { src = s; renderInstall(); });

let steps = [];
function start(fn) {
  steps = [];
  $('#steps').innerHTML = '';
  $('#bar').style.width = '0';
  $('#msg').className = 'msg';
  $('#prog').classList.add('show');
  document.querySelectorAll('#ilist .item').forEach(b => b.disabled = true);
  fn();
}
S.on('job', e => {
  if (e.state === 'step') {
    if (!steps.includes(e.label)) {
      steps.push(e.label);
      $('#steps').innerHTML = steps.map(s => `<span class="s">${s}</span>`).join('');
    }
    $('#steps').querySelectorAll('.s').forEach((x, i) => { x.className = 's' + (i < steps.indexOf(e.label) ? ' done' : i === steps.indexOf(e.label) ? ' on' : ''); });
    const total = e.steps > 1 ? ((e.step + e.pct / 100) / e.steps) * 100 : e.pct;
    $('#bar').style.width = total.toFixed(1) + '%';
    $('#phase').textContent = `${e.label}: ${e.phase}`;
    $('#pct').textContent = Math.round(total) + '%';
  } else if (e.state === 'done') {
    $('#bar').style.width = '100%';
    $('#pct').textContent = '100%';
    $('#steps').querySelectorAll('.s').forEach(x => x.className = 's done');
    const m = $('#msg'); m.className = 'msg ok'; m.textContent = `${e.msg}. The board restarts on its own.`;
    renderInstall();
  } else if (e.state === 'error') {
    const m = $('#msg'); m.className = 'msg err'; m.textContent = e.msg;
    renderInstall();
  }
});

// ---------------------------------------------------------------- SD card
function renderDrives() {
  const l = $('#drives');
  l.innerHTML = '';
  if (!st.drives.length) { l.append(item('No SD card found', 'insert a card reader', null, false, true)); return; }
  for (const d of st.drives) {
    const [id, name, size] = d.split('|');
    l.append(item(`Copy to ${id} ${name || ''}`, size ? kb(+size) : '', async () => {
      const m = $('#sdmsg'); m.className = 'msg info'; m.textContent = 'Copying…';
      const r = await S.sd(d, sdsrc);
      m.className = 'msg ' + (r.ok ? 'ok' : 'err');
      m.textContent = r.ok ? `Copied ${r.copied.join(' and ')} to ${id}. Put the card in the board: Menu › System › System Update.` : r.msg;
    }, true));
  }
}
seg($('#sdsrc'), s => { sdsrc = s; });

// ---------------------------------------------------------------- remote: menu pictures
let font = [];
const PAL = [0x101010, 0x000000, 0x0F380F, 0x242424, 0x3C3C3C, 0x7A7A7A, 0xBEBEBE, 0xFFFFFF,
             0x3A6FF0, 0x9BBC0F, 0xF5C518, 0xE5483C, 0x306230, 0x0E1A33, 0x8BAC0F, 0x000000];
function draw(canvas, rows, cols, top) {
  const g = canvas.getContext('2d'), img = g.createImageData(canvas.width, canvas.height);
  for (let cy = 0; cy < rows.length; cy++) for (let cx = 0; cx < cols; cx++) {
    const v = parseInt(rows[cy].substr(cx * 4, 4), 16), attr = v >> 8, ch = v & 0xFF;
    const fg = PAL[attr & 15], bg = PAL[attr >> 4], code = ch & 0x7F, ext = ch & 0x80;
    for (let py = 0; py < 10; py++) {
      const fy = py - 1;
      const bits = fy < 0 || fy > 7 ? (ext ? font[code * 8 + (fy < 0 ? 0 : 7)] : 0) : font[code * 8 + fy];
      for (let px = 0; px < 8; px++) {
        const c = (bits >> (7 - px)) & 1 ? fg : bg, o = ((top + cy * 10 + py) * canvas.width + cx * 8 + px) * 4;
        img.data[o] = c >> 16; img.data[o + 1] = (c >> 8) & 255; img.data[o + 2] = c & 255; img.data[o + 3] = 255;
      }
    }
  }
  g.putImageData(img, 0, 0);
}
async function shot() {
  const r = await S.shot();
  if (!r) return log('(no menu open: press MENU first)\n');
  draw($('#lcd'), r.lcd, 16, 4);
  draw($('#osd'), r.osd, 42, 0);
}
$('#shot').onclick = shot;

// live picture: the firmware streams the Game Boy frame (changed rows, PackBits) and the menu
// text layers at ~2 Mbaud; composed here like the HDMI output (game 3x, OSD on top) and the LCD
const live = { fb: new Uint16Array(160 * 144), osd: new Uint16Array(42 * 24), lcd: new Uint16Array(16 * 12),
  osdFlags: 0, gbc: 1, raw: 0, dmg: [0xF8F8F8, 0xA8A8A8, 0x585858, 0x101010], frames: 0, t: 0, fps: 0, dirty: false };
function liveRgb(v) {
  if (!live.gbc) return live.dmg[v & 3];
  const r5 = v & 31, g5 = (v >> 5) & 31, b5 = (v >> 10) & 31;
  if (live.raw) return ((r5 << 3 | r5 >> 2) << 16) | ((g5 << 3 | g5 >> 2) << 8) | (b5 << 3 | b5 >> 2);
  return Math.min(255, (r5 * 26 + g5 * 4 + b5 * 2) >> 2) << 16 | Math.min(255, (g5 * 24 + b5 * 8) >> 2) << 8 | Math.min(255, (r5 * 6 + g5 * 4 + b5 * 22) >> 2);
}
// 'A': 16 kHz mono unsigned 8-bit samples; queued back to back with ~80 ms of slack for jitter
let actx = null, aNext = 0;
function liveAudio(p) {
  if (!$('#livesnd').checked || !p.length) return;
  if (!actx) { actx = new AudioContext({ sampleRate: 16000 }); aNext = 0; }
  const buf = actx.createBuffer(1, p.length, 16000), ch = buf.getChannelData(0);
  for (let i = 0; i < p.length; i++) ch[i] = (p[i] - 128) / 128;
  const src = actx.createBufferSource(); src.buffer = buf; src.connect(actx.destination);
  const now = actx.currentTime;
  if (aNext < now + 0.03 || aNext > now + 0.4) aNext = now + 0.08;      // underrun or drift: restart the queue
  src.start(aNext); aNext += p.length / 16000;
}
function liveCells(p, dst) { for (let i = 0; i < dst.length && 2 + i * 2 < p.length; i++) dst[i] = p[1 + i * 2] | p[2 + i * 2] << 8; }
S.on('scr', list => {
  for (const [t, p] of list) {
    if (t === 80) { live.gbc = p[0]; live.raw = p[1]; for (let i = 0; i < 4; i++) live.dmg[i] = p[2 + i * 3] << 16 | p[3 + i * 3] << 8 | p[4 + i * 3]; }
    else if (t === 79) { live.osdFlags = p[0]; liveCells(p, live.osd); }
    else if (t === 76) liveCells(p, live.lcd);
    else if (t === 65) liveAudio(p);
    else if (t === 71) {
      const y = p[0], b = y * 160; let k = 1, x = 0;
      while (k < p.length && x < 160) {
        const c = p[k++];
        if (c < 128) for (let n = 0; n <= c && x < 160; n++, k += 2) live.fb[b + x++] = p[k] | p[k + 1] << 8;
        else { const v = p[k] | p[k + 1] << 8; k += 2; for (let n = 0; n < c - 126 && x < 160; n++) live.fb[b + x++] = v; }
      }
    } else if (t === 70) {
      live.frames++;
      const now = performance.now();
      if (now - live.t > 1000) { live.fps = live.frames * 1000 / (now - live.t); live.frames = 0; live.t = now; }
    }
  }
  live.dirty = true;
});
function liveDrawCells(img, w, h, cells, cols, rows, ox, oy, sc) {
  const d = img.data;
  for (let cy = 0; cy < rows; cy++) for (let cx = 0; cx < cols; cx++) {
    const v = cells[cy * cols + cx], attr = v >> 8, ch = v & 0xFF, code = ch & 0x7F, ext = ch & 0x80;
    for (let py = 0; py < 10; py++) {
      const fy = py - 1;
      const bits = fy < 0 || fy > 7 ? (ext ? font[code * 8 + (fy < 0 ? 0 : 7)] : 0) : font[code * 8 + fy];
      for (let px = 0; px < 8; px++) {
        const ci = (bits >> (7 - px)) & 1 ? attr & 15 : attr >> 4;
        if (!ci) continue;
        const c = PAL[ci];
        for (let sy = 0; sy < sc; sy++) for (let sx = 0; sx < sc; sx++) {
          const x = ox + (cx * 8 + px) * sc + sx, y = oy + (cy * 10 + py) * sc + sy;
          if (x >= w || y >= h) continue;
          const o = (y * w + x) * 4; d[o] = c >> 16; d[o + 1] = (c >> 8) & 255; d[o + 2] = c & 255; d[o + 3] = 255;
        }
      }
    }
  }
}
function liveRender() {
  requestAnimationFrame(liveRender);
  if (!live.dirty || !$('#auto').checked) return;
  live.dirty = false;
  const oc = $('#osd'), lc = $('#lcd');
  if (oc.width !== 720) { oc.width = 720; oc.height = 480; }
  const dim = (live.osdFlags & 3) === 3, k = dim ? 0.4 : 1;
  const g = oc.getContext('2d'), img = g.createImageData(720, 480), d = img.data;
  for (let i = 3; i < d.length; i += 4) d[i] = 255;
  for (let y = 0; y < 144; y++) for (let x = 0; x < 160; x++) {
    const c = liveRgb(live.fb[y * 160 + x]), r = (c >> 16) * k, gg = ((c >> 8) & 255) * k, b = (c & 255) * k;
    for (let sy = 0; sy < 3; sy++) for (let sx = 0; sx < 3; sx++) { const o = ((24 + y * 3 + sy) * 720 + 120 + x * 3 + sx) * 4; d[o] = r; d[o + 1] = gg; d[o + 2] = b; }
  }
  if (live.osdFlags & 1) liveDrawCells(img, 720, 480, live.osd, 42, 24, 24, 0, 2);
  g.putImageData(img, 0, 0);
  const lg = lc.getContext('2d'), li = lg.createImageData(128, 128), ld = li.data;
  for (let i = 3; i < ld.length; i += 4) ld[i] = 255;
  for (let y = 0; y < 115; y++) for (let x = 0; x < 128; x++) {
    const c = liveRgb(live.fb[((y * 144 / 115) | 0) * 160 + ((x * 160 / 128) | 0)]), o = ((y + 6) * 128 + x) * 4;
    ld[o] = (c >> 16) * k; ld[o + 1] = ((c >> 8) & 255) * k; ld[o + 2] = (c & 255) * k;
  }
  if (live.osdFlags & 1) liveDrawCells(li, 128, 128, live.lcd, 16, 12, 0, 4, 1);
  lg.putImageData(li, 0, 0);
  $('#livefps').textContent = `live · ${live.fps.toFixed(0)} fps`;
}
requestAnimationFrame(liveRender);
$('#auto').onchange = async e => {
  const ok = await S.screen(e.target.checked);
  if (!ok) { e.target.checked = false; log('(no board on USB)\n'); return; }
  $('#livefps').textContent = e.target.checked ? 'waiting for the picture (bitstream 1.3, firmware 1.3 or newer)…' : '';
  $('#liveshot').hidden = $('#liverec').hidden = $('#livesndl').hidden = !e.target.checked;
  if (!e.target.checked && rec) rec.stop();
};
// the game 3x and the HDMI picture with the menu, as PNG files
$('#liveshot').onclick = async () => {
  const c = document.createElement('canvas'); c.width = 480; c.height = 432;
  const g = c.getContext('2d'), img = g.createImageData(160, 144);
  for (let i = 0; i < 160 * 144; i++) { const v = liveRgb(live.fb[i]); img.data.set([v >> 16, (v >> 8) & 255, v & 255, 255], i * 4); }
  const t = document.createElement('canvas'); t.width = 160; t.height = 144; t.getContext('2d').putImageData(img, 0, 0);
  g.imageSmoothingEnabled = false; g.drawImage(t, 0, 0, 480, 432);
  const b64 = cv => cv.toDataURL('image/png').split(',')[1];
  const f = await S.savePngs([['', b64(c)], ['_hdmi', b64($('#osd'))]]);
  if (f) log(`screenshot: ${f}\n`);
};
// recording: the HDMI view (game and menu) as WebM, 30 fps
let rec = null;
$('#liverec').onclick = () => {
  if (rec) { rec.stop(); return; }
  const chunks = [];
  rec = new MediaRecorder($('#osd').captureStream(30), { mimeType: 'video/webm;codecs=vp9', videoBitsPerSecond: 4e6 });
  rec.ondataavailable = e => { if (e.data.size) chunks.push(e.data); };
  rec.onstop = async () => {
    rec = null; $('#liverec').textContent = 'Record'; $('#liverec').classList.remove('on');
    const f = await S.saveVideo(await new Blob(chunks, { type: 'video/webm' }).arrayBuffer());
    if (f) log(`video: ${f}\n`);
  };
  rec.start(1000);
  $('#liverec').textContent = '■ Stop'; $('#liverec').classList.add('on');
};

// ---------------------------------------------------------------- board settings
async function cfgLoad() {
  $('#cfgmsg').textContent = 'reading…';
  const r = await S.cfgList();
  if (r.error) { $('#cfgmsg').textContent = r.error; return; }
  const box = $('#cfg'); box.innerHTML = '';
  let page = -1;
  for (const o of r.opts) {
    if (o.page !== page) { page = o.page; const h = document.createElement('h3'); h.textContent = o.pageName; box.append(h); }
    const row = document.createElement('div'); row.className = 'opt';
    const lab = document.createElement('label'); lab.textContent = o.label;
    const sel = document.createElement('select');
    o.options.forEach((t, k) => { const op = document.createElement('option'); op.value = k; op.textContent = t; sel.append(op); });
    sel.value = o.value;
    sel.onchange = async () => {
      sel.disabled = true; $('#cfgmsg').textContent = `${o.label}: saving…`;
      const s = await S.cfgSet(o.page, o.item, +sel.value);
      sel.disabled = false;
      $('#cfgmsg').textContent = s.error ? `${o.label}: ${s.error}` : `${o.label}: ${o.options[+sel.value]}`;
      if (o.label === 'Preset' && !s.error) cfgLoad();          // the preset changes the others
    };
    row.append(lab, sel); box.append(row);
  }
  $('#cfgmsg').textContent = `${r.opts.length} settings`;
}
$('#cfgread').onclick = cfgLoad;
// Normal / Battery: the Power page's Preset
document.querySelectorAll('#pmode button').forEach(b => b.onclick = async () => {
  $('#cfgmsg').textContent = 'switching…';
  const r = await S.cfgList();
  if (r.error) { $('#cfgmsg').textContent = r.error; return; }
  const p = r.opts.find(o => o.label === 'Preset');
  if (!p) { $('#cfgmsg').textContent = 'no Preset setting on this firmware'; return; }
  const s = await S.cfgSet(p.page, p.item, +b.dataset.v);
  document.querySelectorAll('#pmode button').forEach(x => x.classList.toggle('on', x === b && !s.error));
  if (s.error) $('#cfgmsg').textContent = s.error; else cfgLoad();
});

// ---------------------------------------------------------------- remote: buttons
document.querySelectorAll('.k').forEach(b => {
  const k = b.dataset.k;
  b.onpointerdown = () => { b.classList.add('down'); S.key(k, true); };
  const up = () => { if (b.classList.contains('down')) { b.classList.remove('down'); S.key(k, false); } };
  b.onpointerup = up; b.onpointerleave = up;
});
const keymap = { ArrowUp: 'U', ArrowDown: 'D', ArrowLeft: 'L', ArrowRight: 'R', x: 'A', z: 'B', Enter: 'T', Backspace: 'S', m: 'M' };
const held = {};
addEventListener('keydown', e => {
  if (!$('#p-remote').classList.contains('on')) return;
  const k = keymap[e.key]; if (!k || held[k]) return;
  held[k] = 1; e.preventDefault(); S.key(k, true);
  const b = document.querySelector(`.k[data-k="${k}"]`); if (b) b.classList.add('down');
});
addEventListener('keyup', e => {
  const k = keymap[e.key]; if (!k || !held[k]) return;
  held[k] = 0; S.key(k, false);
  const b = document.querySelector(`.k[data-k="${k}"]`); if (b) b.classList.remove('down');
});

// ---------------------------------------------------------------- log
const logEl = $('#log');
function log(t) {
  logEl.textContent += t;
  if (logEl.textContent.length > 80000) logEl.textContent = logEl.textContent.slice(-60000);
  logEl.scrollTop = logEl.scrollHeight;
}
S.on('log', log);
S.on('status', status);

// the dot-matrix accent: OPEN POCKET in the board's own font, one round dot per pixel
function drawArt() {
  const c = $('#art'), g = c.getContext('2d');
  g.fillStyle = '#000'; g.fillRect(0, 0, c.width, c.height);
  const lines = [['OPEN', 2, 34], ['POCKET', 3, 62]];
  for (const [txt, sc, y0] of lines) {
    const w = txt.length * 8 * sc, x0 = (c.width - w) / 2;
    for (let i = 0; i < txt.length; i++) {
      const code = txt.charCodeAt(i);
      for (let fy = 0; fy < 8; fy++) for (let fx = 0; fx < 8; fx++) {
        if (!((font[code * 8 + fy] >> (7 - fx)) & 1)) continue;
        g.fillStyle = '#fff';
        g.beginPath();
        g.arc(x0 + (i * 8 + fx) * sc + sc / 2, y0 + fy * sc + sc / 2, sc * 0.42, 0, 6.3);
        g.fill();
      }
    }
  }
  g.fillStyle = '#7a7a7a'; g.font = '10px sans-serif'; g.textAlign = 'center';
  g.fillText('PRESS START', c.width / 2, 124);
}

(async () => {
  font = (await S.font()).split(/\r?\n/).filter(Boolean).map(h => parseInt(h, 16));
  drawArt();
  status();
  setInterval(status, 5000);
  release = await S.releaseInfo();
  renderInstall();
})();
