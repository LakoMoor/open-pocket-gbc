// Open Pocket IDE on Android: edit the firmware sources (the app keeps them, or a folder on the
// phone) and run a fw.bin on the simulated board (apps/studio/sim, the same model as Studio).
// `Android` is the app's bridge: files(), read(path), write(path, text), source().
'use strict';
const $ = s => document.querySelector(s);
const PAL = [0x101010, 0x000000, 0x0F380F, 0x242424, 0x3C3C3C, 0x7A7A7A, 0xBEBEBE, 0xFFFFFF,
  0x3A6FF0, 0x9BBC0F, 0xF5C518, 0xE5483C, 0x306230, 0x0E1A33, 0x8BAC0F, 0x000000];

document.querySelectorAll('#views button').forEach(b => b.onclick = () => {
  document.querySelectorAll('#views button').forEach(x => x.classList.toggle('on', x === b));
  document.querySelectorAll('.view').forEach(v => v.classList.toggle('on', v.id === b.dataset.v));
  if (b.dataset.v === 'code' && editor) editor.layout();
});

// ---------------------------------------------------------------- editor
let editor = null, cur = null;
require.config({ paths: { vs: 'monaco/vs' } });
require(['vs/editor/editor.main'], () => {
  monaco.editor.defineTheme('pocket', { base: 'vs-dark', inherit: true, rules: [], colors: { 'editor.background': '#0b0b0b', 'editor.lineHighlightBackground': '#161616' } });
  editor = monaco.editor.create($('#editor'), {
    theme: 'pocket', automaticLayout: true, fontSize: 12, minimap: { enabled: false }, lineNumbersMinChars: 3,
    scrollBeyondLastLine: false, wordWrap: 'off', folding: false,
  });
  reloadFiles();
});

function reloadFiles() {
  const files = JSON.parse(Android.files());
  const sel = $('#file');
  sel.innerHTML = '';
  for (const f of files) { const o = document.createElement('option'); o.value = o.textContent = f; sel.append(o); }
  $('#src').textContent = files.length ? Android.source() : 'no sources yet: Get sources or Open folder above';
  cur = null;
  const first = files.includes('fw/src/main.c') ? 'fw/src/main.c' : files[0];
  if (first) { sel.value = first; open(first); } else if (editor) editor.setModel(null);
}
window.ideReload = reloadFiles;
// the app passes the WebView's height in CSS px (100vh is not reliable inside Compose)
window.setViewH = h => { document.documentElement.style.setProperty('--vh', h + 'px'); if (editor) editor.layout(); };

function lang(p) { return /\.(c|h)$/.test(p) ? 'c' : /\.py$/.test(p) ? 'python' : /\.sh$/.test(p) ? 'shell' : /\.md$/.test(p) ? 'markdown' : 'plaintext'; }
function open(p) {
  if (!editor) return;
  if (cur && cur.dirty && !confirm('Discard changes to ' + cur.path + '?')) { $('#file').value = cur.path; return; }
  const text = Android.read(p);
  editor.setModel(monaco.editor.createModel(text, lang(p)));
  cur = { path: p, dirty: false };
  editor.getModel().onDidChangeContent(() => { cur.dirty = true; $('#save').textContent = 'Save •'; });
  $('#save').textContent = 'Save';
}
$('#file').onchange = e => open(e.target.value);
$('#save').onclick = () => {
  if (!cur) return;
  const ok = Android.write(cur.path, editor.getValue());
  if (ok) { cur.dirty = false; $('#save').textContent = 'Saved'; setTimeout(() => $('#save').textContent = 'Save', 1200); }
  else alert('Could not save ' + cur.path);
};

// ---------------------------------------------------------------- simulator
let sim = null, raf = 0, t0 = 0, keys = 0, font = null, coreState = 'reset', audio = null, uartLine = '';
const slog = $('#log');
fetch('../font8x8.hex').then(r => r.text()).then(t => {
  font = t.split(/\s+/).filter(Boolean).map(h => parseInt(h, 16));
});

function uart(c) {
  uartLine += c;
  if (c !== '\n') return;
  if (!/^[0-9a-f]{64,84}\n$/.test(uartLine) && !/^(LCD|OSD)-/.test(uartLine)) {
    slog.textContent += uartLine;
    if (slog.textContent.length > 20000) slog.textContent = slog.textContent.slice(-15000);
    slog.scrollTop = slog.scrollHeight;
  }
  uartLine = '';
}
function beep(v) {
  const hp = v & 0xfff, ms = (v >>> 16) & 0xfff;
  if (!ms) return;
  try {
    audio = audio || new AudioContext();
    const o = audio.createOscillator(), g = audio.createGain();
    o.type = 'square'; o.frequency.value = 1e6 / (8 * (hp + 1)); g.gain.value = 0.04;
    o.connect(g).connect(audio.destination); o.start(); o.stop(audio.currentTime + ms / 1000);
  } catch (e) {}
}

async function start() {
  stop();
  slog.textContent = '';
  $('#state').textContent = 'loading fw.bin…';
  let fw;
  try {
    const r = await fetch('/data/fw.bin', { cache: 'no-store' });
    if (!r.ok) throw new Error('no fw.bin: get one with the fw.bin button above');
    fw = new Uint8Array(await r.arrayBuffer());
  } catch (e) { $('#state').textContent = e.message; return; }
  const flash = new Uint8Array(8 << 20).fill(0xff);
  flash.set(fw, 0x100000);
  sim = new Sim(Board, RV32E, { flash, sd: null, onUart: uart, onBeep: beep, onCore: s => { coreState = s; } });
  t0 = performance.now();
  loop();
}
function stop() { if (raf) cancelAnimationFrame(raf); raf = 0; sim = null; }
function loop() {
  raf = requestAnimationFrame(loop);
  try { sim.runUntil(performance.now() - t0); }
  catch (e) { $('#state').textContent = 'stopped: ' + e.message; cancelAnimationFrame(raf); raf = 0; return; }
  sim.board.setKeys(keys);
  render();
}
$('#run').onclick = start;
$('#reset').onclick = () => { if (sim) start(); };

const hctx = $('#hdmi').getContext('2d'), lctx = $('#lcd').getContext('2d');
const himg = hctx.createImageData(336, 240), limg = lctx.createImageData(128, 128);
function background(img, w, h, dim) {
  const d = img.data;
  for (let y = 0; y < h; y++) for (let x = 0; x < w; x++) {
    let v = coreState === 'run' ? 24 + ((x >> 4) + (y >> 4) & 1) * 10 : 6;
    if (dim) v *= 0.4;
    const o = (y * w + x) * 4; d[o] = d[o + 1] = d[o + 2] = v; d[o + 3] = 255;
  }
}
function cells(img, w, arr, cols, rows, top) {
  const d = img.data;
  for (let cy = 0; cy < rows; cy++) for (let cx = 0; cx < cols; cx++) {
    const v = arr[cy * cols + cx], attr = v >> 8, ch = v & 0xff, code = ch & 0x7f, ext = ch & 0x80;
    for (let py = 0; py < 10; py++) {
      const fy = py - 1;
      const bits = fy < 0 || fy > 7 ? (ext ? font[code * 8 + (fy < 0 ? 0 : 7)] : 0) : font[code * 8 + fy];
      for (let px = 0; px < 8; px++) {
        const ci = (bits >> (7 - px)) & 1 ? attr & 15 : attr >> 4;
        if (ci === 0) continue;                         // transparent: the game shows through
        const y = top + cy * 10 + py;
        if (y >= (img.height || 240)) continue;
        const c = PAL[ci], o = (y * w + cx * 8 + px) * 4;
        d[o] = c >> 16; d[o + 1] = (c >> 8) & 255; d[o + 2] = c & 255; d[o + 3] = 255;
      }
    }
  }
}
function render() {
  if (!font) return;
  const b = sim.board, osdOn = b.ctrl & 0x20, dim = b.ctrl & 0x40;
  background(himg, 336, 240, dim);
  if (osdOn) cells(himg, 336, b.osd, 42, 24, 0);
  hctx.putImageData(himg, 0, 0);
  if (coreState === 'run' && !osdOn) {
    hctx.fillStyle = '#7a7a7a'; hctx.font = '11px sans-serif'; hctx.textAlign = 'center';
    hctx.fillText('game running (the core is not emulated)', 168, 120);
  }
  background(limg, 128, 128, dim);
  if (osdOn) cells(limg, 128, b.lcd, 16, 12, 4);
  lctx.putImageData(limg, 0, 0);
  $('#state').textContent = `${(b.vms / 1000).toFixed(1)} s · core ${coreState}`;
}

// on-screen buttons (and a keyboard, if one is attached)
document.querySelectorAll('[data-k]').forEach(el => {
  const k = +el.dataset.k;
  const down = e => { e.preventDefault(); keys |= k; el.classList.add('down'); };
  const up = e => { e.preventDefault(); keys &= ~k; el.classList.remove('down'); };
  el.addEventListener('touchstart', down, { passive: false });
  el.addEventListener('touchend', up, { passive: false });
  el.addEventListener('touchcancel', up, { passive: false });
  el.addEventListener('mousedown', down); el.addEventListener('mouseup', up); el.addEventListener('mouseleave', up);
});
const map = { ArrowUp: 16, ArrowDown: 32, ArrowLeft: 64, ArrowRight: 128, x: 256, z: 1, Enter: 8, Backspace: 4, Escape: 4096 };
window.addEventListener('keydown', e => { if (document.activeElement && document.activeElement.closest('#editor')) return; const k = map[e.key]; if (k) { keys |= k; e.preventDefault(); } });
window.addEventListener('keyup', e => { const k = map[e.key]; if (k) { keys &= ~k; } });
