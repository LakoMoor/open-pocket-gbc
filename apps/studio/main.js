// Open Pocket Studio, main process: serial port (remote, log, menu dumps), openFPGALoader
// installs with progress, SD update files and downloads from GitHub Releases.
const { app, BrowserWindow, ipcMain, dialog, shell } = require('electron');
const path = require('path');
const fs = require('fs');
const os = require('os');
const https = require('https');
const { spawn, execFile } = require('child_process');
const { SerialPort } = require('serialport');

const REPO = 'LakoMoor/open-pocket-gbc';
const ROOT = path.resolve(__dirname, '..', '..');          // the repository, when run from a checkout
const TOOLS = process.env.TOOLS || (process.platform === 'win32' ? 'E:/tools/oss-cad-suite' : '/opt/oss-cad-suite');
const EXE = process.platform === 'win32' ? '.exe' : '';
// bash runs the build scripts: Git Bash on Windows, the system one elsewhere
const BASH = process.platform !== 'win32' ? 'bash'
  : ['C:/Program Files/Git/bin/bash.exe', 'C:/Program Files (x86)/Git/bin/bash.exe'].find(fs.existsSync) || 'bash.exe';
const BUILD = {
  bitstream: path.join(ROOT, 'build', 'gbc_top', 'gbc_top.fs'),
  firmware: path.join(ROOT, 'fw', 'build', 'fw.bin'),
  games: path.join(ROOT, 'build', 'games.bin'),
};
const CACHE = path.join(app.getPath('userData'), 'release');

let win;
const send = (ch, data) => { if (win && !win.isDestroyed()) win.webContents.send(ch, data); };
const log = text => send('log', text);

// ---------------------------------------------------------------- openFPGALoader
function loaderPath() {
  const exe = 'openFPGALoader' + EXE;
  const local = path.join(TOOLS, 'bin', exe);
  return fs.existsSync(local) ? local : exe;            // otherwise from PATH
}

// .fs (text, one char per bit) -> the bytes the SPI flash holds
function fsToBin(fsPath) {
  const bits = fs.readFileSync(fsPath, 'ascii').split(/\r?\n/).filter(l => l && !l.startsWith('//')).join('');
  const out = Buffer.alloc(Math.ceil(bits.length / 8));
  for (let i = 0; i < bits.length; i++) if (bits.charCodeAt(i) === 49) out[i >> 3] |= 0x80 >> (i & 7);
  return out;
}

// one openFPGALoader run; progress lines look like "Writing: [====   ] 52.93%"
function runLoader(args, label, step, steps) {
  return new Promise((resolve, reject) => {
    send('job', { state: 'step', label, step, steps, pct: 0, phase: 'Starting' });
    let p;
    try {
      // OSS CAD Suite keeps the DLLs openFPGALoader needs in lib/
      const env = { ...process.env, PATH: [path.join(TOOLS, 'bin'), path.join(TOOLS, 'lib'), process.env.PATH].join(path.delimiter) };
      p = spawn(loaderPath(), args, { windowsHide: true, env });
    } catch (e) { return reject(new Error('openFPGALoader not found')); }
    let line = '';
    const feed = chunk => {
      for (const c of chunk.toString('latin1')) {
        if (c === '\r' || c === '\n') {
          const s = line.trim();
          line = '';
          if (!s) continue;
          const m = s.match(/^([A-Za-z ]+):.*?([\d.]+)%$/);
          if (m) send('job', { state: 'step', label, step, steps, pct: parseFloat(m[2]), phase: m[1] === 'Reading' ? 'Verifying' : m[1] });
          else log(s + '\n');
        } else line += c;
      }
    };
    p.stdout.on('data', feed);
    p.stderr.on('data', feed);
    p.on('error', () => reject(new Error('openFPGALoader not found: install OSS CAD Suite or set TOOLS')));
    p.on('close', code => code === 0 ? resolve() : reject(new Error(`${label} failed; if the log says "bulk write", replug the USB cable`)));
  });
}

// items: [{kind: 'bitstream'|'firmware'|'games'|'sram', file}]
let busy = false;
async function install(items) {
  if (busy) return send('job', { state: 'error', msg: 'Another install is running.' });
  busy = true;
  try {
    for (let i = 0; i < items.length; i++) {
      const { kind, file } = items[i];
      if (!file || !fs.existsSync(file)) throw new Error(`missing file for ${kind}`);
      const bin = ['-b', 'tangnano20k', '-f', '--verify'];
      let args, label;
      if (kind === 'sram') { args = ['-b', 'tangnano20k', file]; label = 'Bitstream (SRAM)'; }
      else if (kind === 'bitstream') {
        label = 'Bitstream';
        args = file.endsWith('.fs') ? [...bin, file] : [...bin, '-o', '0', '--file-type', 'bin', file];
      } else if (kind === 'firmware') { label = 'Firmware'; args = [...bin, '-o', '0x100000', '--file-type', 'bin', file]; }
      else { label = 'Games'; args = [...bin, '-o', '0x200000', '--file-type', 'bin', file]; }
      await runLoader(args, label, i, items.length);
    }
    send('job', { state: 'done', msg: items.length > 1 ? 'Everything installed' : 'Installed' });
  } catch (e) {
    send('job', { state: 'error', msg: e.message });
  } finally {
    busy = false;
  }
}

// ---------------------------------------------------------------- GitHub Releases
function getJSON(url) {
  return new Promise((resolve, reject) => {
    https.get(url, { headers: { 'User-Agent': 'open-pocket-studio', Accept: 'application/vnd.github+json' } }, res => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) return getJSON(res.headers.location).then(resolve, reject);
      let b = '';
      res.on('data', d => b += d);
      res.on('end', () => res.statusCode === 200 ? resolve(JSON.parse(b)) : reject(new Error(`GitHub: HTTP ${res.statusCode}`)));
    }).on('error', reject);
  });
}
function download(url, dest, onPct) {
  return new Promise((resolve, reject) => {
    https.get(url, { headers: { 'User-Agent': 'open-pocket-studio', Accept: 'application/octet-stream' } }, res => {
      if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) return download(res.headers.location, dest, onPct).then(resolve, reject);
      if (res.statusCode !== 200) return reject(new Error(`download: HTTP ${res.statusCode}`));
      const total = +res.headers['content-length'] || 0;
      let got = 0;
      const f = fs.createWriteStream(dest);
      res.on('data', d => { got += d.length; if (total) onPct(got / total * 100); });
      res.pipe(f);
      f.on('finish', () => f.close(() => resolve(dest)));
    }).on('error', reject);
  });
}
async function latestRelease() {
  const r = await getJSON(`https://api.github.com/repos/${REPO}/releases/latest`);
  const pick = n => r.assets.find(a => a.name === n);
  return { tag: r.tag_name, name: r.name, published: r.published_at,
           fw: pick('opgbc_fw.bin'), fpga: pick('opgbc_fpga.bin') };
}
async function fetchRelease() {
  const r = await latestRelease();
  fs.mkdirSync(CACHE, { recursive: true });
  const out = {};
  for (const [k, a] of [['firmware', r.fw], ['bitstream', r.fpga]]) {
    if (!a) continue;
    const dest = path.join(CACHE, a.name);
    send('job', { state: 'step', label: 'Download ' + a.name, step: 0, steps: 1, pct: 0, phase: 'Downloading' });
    await download(a.browser_download_url, dest, pct => send('job', { state: 'step', label: 'Download ' + a.name, step: 0, steps: 1, pct, phase: 'Downloading' }));
    out[k] = dest;
  }
  return { tag: r.tag, files: out };
}

// ---------------------------------------------------------------- SD update files
function removableDrives() {
  return new Promise(resolve => {
    if (process.platform !== 'win32') {
      const bases = ['/media', '/run/media', '/Volumes'].filter(fs.existsSync);
      const out = [];
      for (const b of bases) for (const d of fs.readdirSync(b)) out.push(path.join(b, d));
      return resolve(out);
    }
    execFile('powershell.exe', ['-NoProfile', '-Command',
      'Get-CimInstance Win32_LogicalDisk -Filter DriveType=2 | ForEach-Object { $_.DeviceID + "|" + $_.VolumeName + "|" + $_.Size }'],
      { windowsHide: true }, (err, out) => {
        if (err) return resolve([]);
        resolve(out.split(/\r?\n/).filter(Boolean).map(l => l.trim()));
      });
  });
}
async function writeSd(drive, src) {
  const root = drive.split('|')[0] + (process.platform === 'win32' ? '\\' : '/');
  const copied = [];
  if (src.firmware && fs.existsSync(src.firmware)) { fs.copyFileSync(src.firmware, path.join(root, 'opgbc_fw.bin')); copied.push('opgbc_fw.bin'); }
  if (src.bitstream && fs.existsSync(src.bitstream)) {
    const data = src.bitstream.endsWith('.fs') ? fsToBin(src.bitstream) : fs.readFileSync(src.bitstream);
    if (data.length > 0x100000) throw new Error('bitstream larger than 1 MB');
    fs.writeFileSync(path.join(root, 'opgbc_fpga.bin'), data);
    copied.push('opgbc_fpga.bin');
  }
  return copied;
}

// ---------------------------------------------------------------- serial port
let port = null, rx = '', dumpWait = null;
async function findPort() {
  const list = await SerialPort.list();
  const p = list.find(p => (p.vendorId || '').toLowerCase() === '0403' && (p.productId || '').toLowerCase() === '6010');
  return p ? p.path : null;
}
async function connect() {
  if (port && port.isOpen) return true;
  const p = await findPort();
  if (!p) return false;
  return new Promise(resolve => {
    port = new SerialPort({ path: p, baudRate: 115200 }, err => {
      if (err) { log(`serial: ${err.message}\n`); port = null; return resolve(false); }
      send('status', null);
      resolve(true);
    });
    port.on('data', onData);
    port.on('close', () => { port = null; scrOn = false; scrFast = false; send('status', null); });
    port.on('error', e => log(`serial: ${e.message}\n`));
  });
}
// ---- live screen: 'V' makes the firmware switch to ~2 Mbaud and stream the picture (fw scr_poll)
let scrOn = false, scrFast = false, scrTimer = null, scrPk = [];
const pk = { st: 0, type: 0, len: 0, pos: 0, buf: null };
function screen(on) {
  if (on === scrOn) return;
  scrOn = on;
  if (on) {
    port.write('V');
    let n = 0;
    scrTimer = setInterval(() => { if (port && port.isOpen) port.write(!scrFast && ++n % 2 === 0 ? 'V' : '.'); }, 1000);
  } else {
    clearInterval(scrTimer); scrTimer = null;
    if (port && port.isOpen) { port.write('v'); setTimeout(() => { if (port && port.isOpen) port.update({ baudRate: 115200 }); scrFast = false; }, 60); }
  }
}
function onBinary(d) {
  let text = '';
  for (const v of d) {
    switch (pk.st) {
      case 0: if (v === 0) pk.st = 1; else text += String.fromCharCode(v); break;
      case 1: pk.type = v; pk.st = 2; break;
      case 2: pk.len = v; pk.st = 3; break;
      case 3: pk.len |= v << 8; pk.pos = 0; pk.buf = new Uint8Array(pk.len); pk.st = pk.len ? 4 : 0; if (!pk.len) scrPk.push([pk.type, pk.buf]); break;
      case 4: pk.buf[pk.pos++] = v; if (pk.pos === pk.len) { scrPk.push([pk.type, pk.buf]); pk.st = 0; if (pk.type === 70) { send('scr', scrPk); scrPk = []; } } break;
    }
  }
  if (scrPk.length > 40) { send('scr', scrPk); scrPk = []; }
  return text;
}
function onData(d) {
  if (scrFast) { const t = onBinary(d); if (!t) return; d = Buffer.from(t, 'latin1'); }
  rx += d.toString('latin1');
  if (scrOn && !scrFast && rx.includes('#SCR ')) {
    scrFast = true;
    port.update({ baudRate: 2000000 }, e => log(e ? `serial: ${e.message}\n` : 'screen stream at 2 Mbaud\n'));
  }
  if (dumpWait) {
    if (rx.includes('OSD-END')) { const r = rx; rx = ''; dumpWait(r); dumpWait = null; }
    return;
  }
  const i = rx.lastIndexOf('\n');
  if (i < 0) return;
  const text = rx.slice(0, i + 1);
  rx = rx.slice(i + 1);
  const lines = text.split('\n').filter(l => l && !/^[0-9a-f]{64}$|^[0-9a-f]{84}$|^(LCD|OSD)-/.test(l.trim()));
  if (lines.length) log(lines.join('\n') + '\n');
}
const sleep = ms => new Promise(r => setTimeout(r, ms));
async function key(k, down) {
  if (!(await connect())) return false;
  if (down === undefined) { port.write(k.toUpperCase()); await sleep(100); port.write(k.toLowerCase()); }
  else port.write(down ? k.toUpperCase() : k.toLowerCase());
  return true;
}
// Select in the menu prints the LCD (16 x 12) and HDMI (42 x 24) text buffers
async function menuShot() {
  if (!(await connect())) return null;
  rx = '';
  const p = new Promise(res => { dumpWait = res; setTimeout(() => { if (dumpWait) { dumpWait = null; res(null); } }, 2500); });
  await key('S');
  const t = await p;
  if (!t || !t.includes('LCD-BEGIN')) return null;
  const grab = (a, b, w) => t.split(a)[1].split(b)[0].split(/\r?\n/).map(l => l.trim()).filter(l => l.length === w * 4);
  return { lcd: grab('LCD-BEGIN', 'LCD-END', 16), osd: grab('OSD-BEGIN', 'OSD-END', 42) };
}

// ---------------------------------------------------------------- IPC
function fileInfo() {
  const out = {};
  for (const [k, p] of Object.entries(BUILD)) if (fs.existsSync(p)) { const s = fs.statSync(p); out[k] = { path: p, size: s.size, mtime: s.mtimeMs }; }
  return out;
}
ipcMain.handle('status', async () => ({ port: await findPort(), connected: !!(port && port.isOpen), build: fileInfo(), drives: await removableDrives() }));
ipcMain.handle('install', (_, items) => { install(items); return true; });
ipcMain.handle('screen', async (_, on) => { if (on && !(await connect())) return false; if (port) screen(on); return true; });
ipcMain.handle('install-build', (_, which) => {
  const items = which === 'all' ? [{ kind: 'bitstream', file: BUILD.bitstream }, { kind: 'firmware', file: BUILD.firmware }]
    : which === 'sram' ? [{ kind: 'sram', file: BUILD.bitstream }] : [{ kind: which, file: BUILD[which] }];
  install(items);
  return true;
});
ipcMain.handle('install-release', async () => {
  try {
    const r = await fetchRelease();
    const items = [];
    if (r.files.bitstream) items.push({ kind: 'bitstream', file: r.files.bitstream });
    if (r.files.firmware) items.push({ kind: 'firmware', file: r.files.firmware });
    if (!items.length) throw new Error('the release has no update files');
    log(`release ${r.tag}\n`);
    install(items);
  } catch (e) { send('job', { state: 'error', msg: e.message }); }
  return true;
});
ipcMain.handle('release-info', async () => { try { return await latestRelease(); } catch (e) { return { error: e.message }; } });
ipcMain.handle('pick', async (_, kind) => {
  const filters = kind === 'bitstream' ? [{ name: 'Bitstream', extensions: ['fs', 'bin'] }] : [{ name: 'Binary', extensions: ['bin'] }];
  const r = await dialog.showOpenDialog(win, { properties: ['openFile'], filters });
  return r.canceled ? null : r.filePaths[0];
});
ipcMain.handle('sd', async (_, drive, source) => {
  try {
    let src = { firmware: BUILD.firmware, bitstream: BUILD.bitstream };
    if (source === 'release') src = (await fetchRelease()).files;
    const copied = await writeSd(drive, src);
    send('job', { state: 'idle' });
    return { ok: true, copied };
  } catch (e) { return { ok: false, msg: e.message }; }
});
ipcMain.handle('key', (_, k, down) => key(k, down));
ipcMain.handle('connect', () => connect());
ipcMain.handle('shot', () => menuShot());
ipcMain.handle('font', () => {
  for (const p of [path.join(ROOT, 'rtl', 'video', 'font8x8.hex'), path.join(__dirname, 'assets', 'font8x8.hex')])
    if (fs.existsSync(p)) return fs.readFileSync(p, 'ascii');
  return '';
});
ipcMain.handle('open', (_, url) => shell.openExternal(url));

// ---------------------------------------------------------------- IDE and simulator
const SIMDIR = path.join(app.getPath('userData'), 'sim');
const SRC_DIRS = [path.join(ROOT, 'fw', 'src'), path.join(ROOT, 'fw', 'home')];
const SD_DIR_DEFAULT = path.join(ROOT, 'games');
let buildProc = null;

function listSources() {
  const out = [];
  for (const d of SRC_DIRS) if (fs.existsSync(d))
    for (const f of fs.readdirSync(d).sort())
      if (/\.(c|h|S|asm|py|ld|sh)$/.test(f)) out.push({ path: path.join(d, f), name: path.relative(path.join(ROOT, 'fw'), path.join(d, f)).split(path.sep).join('/') });
  return out;
}
function insideSources(p) { return SRC_DIRS.some(d => path.resolve(p).startsWith(d + path.sep)); }

// the flash image of the simulated board: firmware at 0x100000, games at 0x200000, the rest kept
function simFlash(freshFw) {
  fs.mkdirSync(SIMDIR, { recursive: true });
  const file = path.join(SIMDIR, 'flash.bin');
  let img;
  if (fs.existsSync(file)) img = new Uint8Array(fs.readFileSync(file));
  else {
    img = new Uint8Array(8 << 20).fill(0xff);
    if (fs.existsSync(BUILD.games)) img.set(fs.readFileSync(BUILD.games), 0x200000);
    freshFw = true;
  }
  if (freshFw && fs.existsSync(BUILD.firmware)) { img.fill(0xff, 0x100000, 0x200000); img.set(fs.readFileSync(BUILD.firmware), 0x100000); }
  return img;
}
function simSd(rebuild) {
  const file = path.join(SIMDIR, 'sd.img');
  if (!rebuild && fs.existsSync(file)) return new Uint8Array(fs.readFileSync(file));
  const { buildImage } = require('./sim/fat');
  const tmp = path.join(SIMDIR, 'sd_src');
  fs.rmSync(tmp, { recursive: true, force: true });
  fs.mkdirSync(tmp, { recursive: true });
  if (fs.existsSync(SD_DIR_DEFAULT)) for (const f of fs.readdirSync(SD_DIR_DEFAULT)) fs.copyFileSync(path.join(SD_DIR_DEFAULT, f), path.join(tmp, f));
  if (fs.existsSync(BUILD.firmware)) fs.copyFileSync(BUILD.firmware, path.join(tmp, 'opgbc_fw.bin'));     // lets you try System Update
  const img = buildImage(tmp, 32);
  fs.writeFileSync(file, img);
  return img;
}

ipcMain.handle('ide-files', () => listSources());
ipcMain.handle('ide-read', (_, p) => insideSources(p) ? fs.readFileSync(p, 'utf8') : null);
ipcMain.handle('ide-write', (_, p, text) => { if (!insideSources(p)) return false; fs.writeFileSync(p, text.replace(/\r\n/g, '\n')); return true; });
ipcMain.handle('ide-build', () => new Promise(resolve => {
  if (buildProc) return resolve(-1);
  buildProc = spawn(BASH, [path.join(ROOT, 'fw', 'build.sh')], { cwd: path.join(ROOT, 'fw'), windowsHide: true });
  const fwd = d => send('build-log', d.toString());
  buildProc.stdout.on('data', fwd);
  buildProc.stderr.on('data', fwd);
  buildProc.on('error', e => { send('build-log', e.message + '\n'); buildProc = null; resolve(-1); });
  buildProc.on('close', code => { buildProc = null; resolve(code); });
}));
ipcMain.handle('sim-load', (_, opts) => ({ flash: simFlash(opts && opts.freshFw), sd: simSd(opts && opts.rebuildSd) }));
ipcMain.handle('sim-save', (_, flash, sd) => {
  fs.mkdirSync(SIMDIR, { recursive: true });
  if (flash) fs.writeFileSync(path.join(SIMDIR, 'flash.bin'), flash);
  if (sd) fs.writeFileSync(path.join(SIMDIR, 'sd.img'), sd);
  return true;
});

// ---- the Tang Nano 20K RTL simulator (sim/tang, Verilator): frames and the log over stdout
const RTL_EXE = path.join(ROOT, 'build', 'tang_sim', 'tang_sim' + EXE);
let rtlProc = null;
ipcMain.handle('rtl-available', () => fs.existsSync(RTL_EXE));
ipcMain.handle('rtl-build', () => new Promise(resolve => {
  const p = spawn(BASH, [path.join(ROOT, 'sim', 'tang', 'build.sh')], { cwd: ROOT, windowsHide: true });
  const fwd = d => send('build-log', d.toString());
  p.stdout.on('data', fwd); p.stderr.on('data', fwd);
  p.on('error', e => { send('build-log', e.message + '\n'); resolve(-1); });
  p.on('close', code => resolve(code));
}));
ipcMain.handle('rtl-start', (_, opts) => {
  if (rtlProc) { rtlProc.kill(); rtlProc = null; }
  if (!fs.existsSync(RTL_EXE)) return { ok: false, msg: 'build the simulator first (Build RTL)' };
  const flash = simFlash(opts && opts.freshFw);
  fs.writeFileSync(path.join(SIMDIR, 'flash.bin'), flash);
  simSd(false);
  const args = ['--flash', path.join(SIMDIR, 'flash.bin'), '--sd', path.join(SIMDIR, 'sd.img')];
  if (opts && opts.noHdmi) args.push('--no-hdmi');
  const p = spawn(RTL_EXE, args, { cwd: ROOT, windowsHide: true });
  rtlProc = p;
  let buf = Buffer.alloc(0);
  p.stdout.on('data', d => {
    buf = buf.length ? Buffer.concat([buf, d]) : d;
    while (buf.length >= 5) {
      const n = buf.readUInt32LE(1);
      if (buf.length < 5 + n) break;
      const type = String.fromCharCode(buf[0]), data = buf.subarray(5, 5 + n);
      if (type === 'L') send('rtl-log', data.toString('latin1'));
      else if (type === 'B') send('rtl-band', new Uint8Array(data));   // u16 y0, u16 rows, rows x 720 RGB
      else if (type === 'C') send('rtl-lcd', new Uint8Array(data));
      else if (type === 'T') send('rtl-time', data.readUInt32LE(0));
      buf = buf.subarray(5 + n);
    }
  });
  p.stderr.on('data', d => send('rtl-log', d.toString()));
  p.on('close', code => { if (rtlProc === p) rtlProc = null; send('rtl-exit', code); });
  return { ok: true };
});
ipcMain.handle('rtl-key', (_, bits) => { if (rtlProc) rtlProc.stdin.write('K ' + bits.toString(16) + '\n'); return true; });
ipcMain.handle('rtl-remote', (_, ch) => { if (rtlProc) rtlProc.stdin.write('R ' + ch + '\n'); return true; });
ipcMain.handle('rtl-stop', () => {
  if (!rtlProc) return true;
  const p = rtlProc;
  p.stdin.write('Q\n');
  setTimeout(() => { try { p.kill(); } catch (e) {} }, 3000);
  rtlProc = null;
  return true;
});
ipcMain.handle('sim-reset-flash', () => { fs.rmSync(path.join(SIMDIR, 'flash.bin'), { force: true }); return true; });
ipcMain.handle('sim-sd-open', (_, sd) => {
  const { readImage } = require('./sim/fat');
  const out = path.join(SIMDIR, 'sd_files');
  fs.rmSync(out, { recursive: true, force: true });
  for (const [name, data] of Object.entries(readImage(sd))) {
    const p = path.join(out, name);
    fs.mkdirSync(path.dirname(p), { recursive: true });
    fs.writeFileSync(p, data);
  }
  shell.openPath(out);
  return out;
});


app.whenReady().then(() => {
  win = new BrowserWindow({
    width: 1180, height: 860, minWidth: 720, minHeight: 600, backgroundColor: '#0d0f17',
    title: 'Open Pocket Studio', autoHideMenuBar: true,
    webPreferences: { preload: path.join(__dirname, 'preload.js'), contextIsolation: true, nodeIntegration: false },
  });
  win.loadFile(path.join(__dirname, 'renderer', 'index.html'));
});
app.on('window-all-closed', () => { if (port && port.isOpen) port.close(); if (rtlProc) rtlProc.kill(); app.quit(); });
if (process.env.STUDIO_SHOT) require(process.env.STUDIO_SHOT);      // screenshots for the docs
