import { PocketSerial } from './serial.mjs';
import { decodeRow } from './protocol.mjs';
import { t, mountLanguages } from './i18n.mjs';
const $ = s => document.querySelector(s), board = new PocketSerial();
const canvas = $('#screen'), ctx = canvas.getContext('2d');
const fb = new Uint16Array(160 * 144), cells = new Uint16Array(42 * 24);
const palette = [0x101010,0,0x0f380f,0x242424,0x3c3c3c,0x7a7a7a,0xbebebe,0xffffff,0x3a6ff0,0x9bbc0f,0xf5c518,0xe5483c,0x306230,0x0e1a33,0x8bac0f,0];
let font = [], gbc = true, raw = false, dmg = [0xf8f8f8,0xa8a8a8,0x585858,0x101010], flags = 0;
let options = [], busy = false, frameSeen = false, lastFrame = 0, frames = 0, frameTime = performance.now(), dirty = false;
const sources = new Map();
let noticeSource='', pristineLog=true;
let settingsMessage='Подключи плату и прочитай настройки. Нужна прошивка 1.6 или новее.', settingsValues={};
function settingsStatus(message, values={}) { settingsMessage=message;settingsValues=values;$('#settings-status').textContent=t(message,values); }
function notice(text) { noticeSource=text;$('#notice').textContent = t(text); $('#notice').hidden = !text; }
function log(text) {
  pristineLog=false;
  const el = $('#log'); el.textContent = (el.textContent + text).slice(-60000); el.scrollTop = el.scrollHeight;
  $('#log-count').textContent = el.textContent.split('\n').length - 1;
}
function fail(e) { notice(e.message || String(e)); log(`[USB] ${t(e.message || String(e))}\n`); }
async function run(task) {
  if (busy) return;
  releaseAll();
  busy = true; update();
  try { notice(''); return await task(); } catch (e) { fail(e); }
  finally { busy = false; update(); }
}
function update() {
  const connected = !!board.port;
  $('#connect').textContent = t(connected ? 'Отключить плату' : 'Подключить плату ↗');
  $('#connect').disabled = busy;
  for (const el of document.querySelectorAll('#options select')) el.disabled = busy || !connected;
  $('#led').classList.toggle('connected', connected);
  $('#connection').textContent = t(connected ? 'USB подключён' : 'Нет подключения');
  $('#board-title').textContent = t(connected ? 'Плата на связи.' : 'Готов, когда ты.');
  $('#board-detail').textContent = t(connected ? 'Управляй с клавиатуры или кнопками ниже. Изменения настроек сохраняются на плате.' : 'Подключи USB-кабель с передачей данных. Выбери последовательный порт платы, обычно USB Serial Port B.');
  for (const el of document.querySelectorAll('[data-board], [data-key]')) el.disabled = !connected || busy;
  $('#stream').textContent = t(board.streaming ? 'Остановить экран' : 'Включить экран');
  $('#screenshot').disabled = !frameSeen;
  $('#screen-status').textContent = t(board.streaming ? 'ТРАНСЛЯЦИЯ · USB' : 'ЭКРАН ПЛАТЫ');
  if(!('serial' in navigator)||!isSecureContext)$('#connect').disabled=true;
}
function view(id) {
  if (!document.getElementById(id)?.classList.contains('view')) id = 'play';
  releaseAll();
  for (const el of document.querySelectorAll('.view')) el.hidden = el.id !== id;
  for (const el of document.querySelectorAll('.nav')) {
    el.classList.toggle('active', el.dataset.view === id);
    if (el.dataset.view === id) el.setAttribute('aria-current','page'); else el.removeAttribute('aria-current');
  }
}
for (const el of document.querySelectorAll('[data-view], [data-goto]')) el.onclick = e => { e.preventDefault(); view(el.dataset.view || el.dataset.goto); };
$('#connect').onclick = () => run(async () => {
  releaseAll();
  if (board.port) await board.disconnect(); else await board.connect();
});
board.addEventListener('connection', e => {
  if (!e.detail) { sources.clear(); for (const el of document.querySelectorAll('.down')) el.classList.remove('down'); $('#fps').textContent = 'USB OFFLINE'; }
  log('[USB] '+t(e.detail ? 'Подключено на 115200 бод' : 'Отключено')+'\n'); update();
});
board.addEventListener('error', e => fail(e.detail));
board.addEventListener('text', e => {
  log(e.detail);
  const m = e.detail.match(/#HELLO (\S+)/); if (m) $('#version').textContent = `FIRMWARE ${m[1]}`;
});
$('#stream').onclick = () => run(async () => { if (board.streaming) await board.stopScreen(); else await board.startScreen(); });
function key(source, k, down) {
  if (!board.port || busy || board.session) return;
  const was = [...sources.values()].includes(k);
  if (down) sources.set(source, k); else sources.delete(source);
  const now = [...sources.values()].includes(k);
  if (was !== now) board.write(now ? k : k.toLowerCase()).catch(fail);
  document.querySelector(`[data-key="${k}"]`)?.classList.toggle('down', now);
}
function releaseAll() {
  if (!sources.size) return;
  sources.clear();
  for (const el of document.querySelectorAll('.down')) el.classList.remove('down');
  if (board.port && !board.session) board.write('0').catch(fail);
}
for (const el of document.querySelectorAll('[data-key]')) {
  el.onpointerdown = e => { e.preventDefault(); el.setPointerCapture(e.pointerId); key(`p${e.pointerId}`, el.dataset.key, true); };
  const up = e => key(`p${e.pointerId}`, el.dataset.key, false);
  el.onpointerup = up; el.onpointercancel = up; el.onlostpointercapture = up;
  // Accessible activation for assistive technology that synthesizes click without pointer events.
  el.onclick = e => { if (e.detail === 0) { const source = `click${el.dataset.key}`; key(source, el.dataset.key, true); setTimeout(() => key(source, el.dataset.key, false), 100); } };
}
const keys = { ArrowUp:'U',ArrowDown:'D',ArrowLeft:'L',ArrowRight:'R',x:'A',z:'B',Enter:'T',Backspace:'S',m:'M' };
addEventListener('keydown', e => {
  if ($('#play').hidden || /INPUT|SELECT|TEXTAREA|BUTTON/.test(e.target.tagName) || e.ctrlKey || e.altKey || e.metaKey) return;
  const k = keys[e.key.length === 1 ? e.key.toLowerCase() : e.key];
  if (!k || e.repeat) return; e.preventDefault(); key(`k${e.code}`,k,true);
});
addEventListener('keyup', e => { const k = sources.get(`k${e.code}`); if (k) { e.preventDefault(); key(`k${e.code}`,k,false); } });
addEventListener('blur', releaseAll);
document.addEventListener('visibilitychange', () => { if (document.hidden) { releaseAll(); if (board.streaming && !busy) run(() => board.stopScreen()); } });
function rgb(v) {
  if (!gbc) return dmg[v & 3];
  const r=v&31,g=v>>5&31,b=v>>10&31;
  if (raw) return (r<<3|r>>2)<<16 | (g<<3|g>>2)<<8 | b<<3|b>>2;
  return Math.min(255,(r*26+g*4+b*2)>>2)<<16 | Math.min(255,(g*24+b*8)>>2)<<8 | Math.min(255,(r*6+g*4+b*22)>>2);
}
board.addEventListener('packet', ({detail:{type,data:p}}) => {
  if (type === 'P' && p.length === 14) { gbc=!!p[0];raw=!!p[1];for(let i=0;i<4;i++) dmg[i]=p[2+i*3]<<16|p[3+i*3]<<8|p[4+i*3]; }
  if (type === 'O' && p.length) { flags=p[0];if(p.length===2017)for(let i=0;i<cells.length;i++)cells[i]=p[1+i*2]|p[2+i*2]<<8; }
  if (type === 'G' || type === 'R') { const row=decodeRow(type,p);if(row)fb.set(row.pixels,row.y*160); }
  if (type === 'F') { frames++;frameSeen=true;lastFrame=performance.now();$('#empty').hidden=true;update(); }
  dirty=true;
});
function render() {
  requestAnimationFrame(render);
  const now=performance.now();
  if (now-frameTime>1500) { $('#fps').textContent=board.streaming ? (now-lastFrame>5000 ? t('ОЖИДАНИЕ КАДРА') : `${(frames*1000/(now-frameTime)).toFixed(1)} FPS`) : 'USB LIVE';frames=0;frameTime=now; }
  if (!dirty || !frameSeen) return; dirty=false;
  const image=ctx.createImageData(720,480), d=image.data, dim=(flags&3)===3?.4:1;
  for(let i=3;i<d.length;i+=4)d[i]=255;
  function pixel(x,y,c,k=1) { const at=(y*720+x)*4;d[at]=(c>>16)*k;d[at+1]=(c>>8&255)*k;d[at+2]=(c&255)*k; }
  for(let y=0;y<144;y++)for(let x=0;x<160;x++){const c=rgb(fb[y*160+x]);for(let yy=0;yy<3;yy++)for(let xx=0;xx<3;xx++)pixel(120+x*3+xx,24+y*3+yy,c,dim);}
  if(flags&1)for(let cy=0;cy<24;cy++)for(let cx=0;cx<42;cx++){
    const v=cells[cy*42+cx],attr=v>>8,ch=v&127,ext=v&128;
    for(let py=0;py<10;py++){const fy=py-1,bits=fy<0||fy>7?(ext?font[ch*8+(fy<0?0:7)]:0):font[ch*8+fy];
      for(let px=0;px<8;px++){const ci=bits>>(7-px)&1?attr&15:attr>>4;if(!ci)continue;for(let yy=0;yy<2;yy++)for(let xx=0;xx<2;xx++)pixel(24+(cx*8+px)*2+xx,(cy*10+py)*2+yy,palette[ci]);}
    }
  }
  ctx.putImageData(image,0,0);
}
requestAnimationFrame(render);
function download(blob, name) { const url=URL.createObjectURL(blob),a=document.createElement('a');a.href=url;a.download=name;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000); }
$('#screenshot').onclick=()=>canvas.toBlob(blob=>{if(blob)download(blob,`open-pocket-${Date.now()}.png`);});
$('#fullscreen').onclick=()=>{if(document.fullscreenElement)document.exitFullscreen().catch(fail);else $('#display').requestFullscreen?.().catch(fail);};
$('#clear-log').onclick=()=>{pristineLog=false;$('#log').textContent='';$('#log-count').textContent='0';};
$('#download-log').onclick=()=>download(new Blob([$('#log').textContent],{type:'text/plain;charset=utf-8'}),'open-pocket.log');
const pages=['Экран','Звук','Управление','Система','Питание'];
function renderOptions() {
  const root=$('#options'), filter=$('#search').value.toLowerCase();root.replaceChildren();
  const visible=options.filter(o=>`${o.label} ${pages[o.page]} ${t(pages[o.page])} ${o.choices.join(' ')}`.toLowerCase().includes(filter));
  for(let p=0;p<pages.length;p++) {
    const opts=visible.filter(o=>o.page===p);if(!opts.length)continue;
    const h=document.createElement('h2');h.textContent=t(pages[p]);root.append(h);
    for(const o of opts) {
      const row=document.createElement('div'),label=document.createElement('label'),sel=document.createElement('select');
      row.className='option';label.textContent=o.label;sel.id=`opt-${o.page}-${o.item}`;label.htmlFor=sel.id;
      o.choices.forEach((name,i)=>{const option=document.createElement('option');option.value=i;option.textContent=name;sel.append(option);});sel.value=o.value;
      sel.onchange=()=>run(async()=>{
        releaseAll();sel.disabled=true;
        try { await board.setOption(o,+sel.value);options=await board.options();renderOptions();settingsStatus('Настройки сохранены на плате.'); }
        finally { sel.value=o.value;sel.disabled=false; }
      });row.append(label,sel);root.append(row);
    }
  }
  if(!visible.length&&options.length){const p=document.createElement('p');p.textContent=t('Настройки не найдены');root.append(p);}
}
$('#search').oninput=renderOptions;
$('#read-settings').onclick=()=>run(async()=>{releaseAll();options=await board.options();renderOptions();settingsStatus('Прочитано настроек: {count}. Трансляцию можно снова включить на странице пульта.',{count:options.length});});
if(!('serial' in navigator)||!isSecureContext) { $('#connect').disabled=true;notice('USB требует Chrome или Edge на компьютере и страницу по HTTPS или localhost. Подробности — в разделе «Подключение».'); }
fetch('font8x8.hex').then(r=>{if(!r.ok)throw new Error('Не удалось загрузить шрифт меню');return r.text();}).then(text=>{
  font=text.trim().split(/\s+/).map(h=>parseInt(h,16));dirty=true;
  const mark=$('#wordmark'),g=mark.getContext('2d');g.fillStyle='#fff';
  for(const [word,y] of [['OPEN',3],['POCKET',24]]) {
    const scale=2,start=(160-word.length*8*scale)/2;
    for(let c=0;c<word.length;c++)for(let y1=0;y1<8;y1++)for(let x=0;x<8;x++)if(font[word.charCodeAt(c)*8+y1]>>(7-x)&1){g.beginPath();g.arc(start+(c*8+x)*scale+1,y+y1*scale+1,.8,0,Math.PI*2);g.fill();}
  }
}).catch(fail);
mountLanguages(()=>{
  releaseAll();update();renderOptions();notice(noticeSource);settingsStatus(settingsMessage,settingsValues);
  if(pristineLog)$('#log').textContent=t('Open Pocket Web Studio готов к подключению.')+'\n';
});
