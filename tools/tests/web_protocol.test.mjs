import test from 'node:test';
import assert from 'node:assert/strict';
import { StreamParser, decodeRow, parseOptions } from '../../docs/web/protocol.mjs';
import { PocketSerial } from '../../docs/web/serial.mjs';

test('packets and text survive arbitrary serial chunk boundaries', () => {
  const packets=[],text=[];
  const parser=new StreamParser((t,p)=>packets.push([t,[...p]]),t=>text.push(t));
  const bytes=[...new TextEncoder().encode('#SCR 115200\n'),0,80,3,0,1,0,10,0,70,2,0,42,0];
  for(const b of bytes)parser.feed([b]);
  assert.equal(text.join(''),'#SCR 115200\n');
  assert.deepEqual(packets,[['P',[1,0,10]],['F',[42,0]]]);
});
test('R rows end at 80 words, including literal and repeat runs', () => {
  const row=[7,1,1,0,2,0,3,0,4,0,204,5,0,6,0]; // 2 literal words + 78 repeats
  const out=[];const parser=new StreamParser((t,p)=>out.push([t,p]));
  parser.feed([0,82,...row,0,70,2,0,1,0]);
  assert.equal(out.length,2);assert.equal(out[0][0],'R');assert.equal(out[1][0],'F');
  const decoded=decodeRow('R',out[0][1]);assert.equal(decoded.y,7);
  assert.deepEqual([...decoded.pixels.slice(0,8)],[1,2,3,4,5,6,5,6]);assert.equal(decoded.pixels[159],6);
});
test('G rows decode repeated and literal pixels',()=>{
  const row=decodeRow('G',Uint8Array.from([2,0,31,0,255,0,124,128,0,124])); // 1 + 129 + 2 = 132: reject incomplete
  assert.equal(row,null);
  const valid=decodeRow('G',Uint8Array.from([2,255,31,0,157,0,124])); // 129 + 31 = 160
  assert.equal(valid.pixels[128],31);assert.equal(valid.pixels[129],31744);
});
test('invalid rows and truncated/overflowing runs are rejected',()=>{
  assert.equal(decodeRow('R',new Uint8Array([144,206,0,0,0,0])),null);
  assert.equal(decodeRow('R',new Uint8Array([0,206,0,0])),null);
  assert.equal(decodeRow('R',new Uint8Array([0,207,0,0,0,0])),null);
});
test('settings preserve firmware page/item identities and untrusted labels as data',()=>{
  assert.deepEqual(parseOptions('noise\nopt 4 7 1|<b>Preset</b>|Normal;Battery\r\nend\n'),[
    {page:4,item:7,value:1,label:'<b>Preset</b>',choices:['Normal','Battery']}
  ]);
});
test('oversized packets cannot grow an unbounded payload',()=>{
  const parser=new StreamParser(()=>assert.fail('unexpected packet'));
  parser.feed([0,79,255,255]);assert.equal(parser.state,'text');assert.equal(parser.payload.length,0);
});
test('serial writes are ordered and release their stream lock',async()=>{
  const seen=[];let locked=false;
  const serial=new PocketSerial();serial.port={writable:{getWriter(){assert.equal(locked,false);locked=true;return{
    async write(data){await new Promise(r=>setTimeout(r,2));seen.push(new TextDecoder().decode(data));},releaseLock(){locked=false;}
  };}}};
  await Promise.all([serial.write('U'),serial.write('u'),serial.write('0')]);
  assert.deepEqual(seen,['U','u','0']);assert.equal(locked,false);
});
test('old queued writes never leak into a newly connected port',async()=>{
  const serial=new PocketSerial();const port={writable:{getWriter(){assert.fail('stale port used');}}};
  serial.port=port;const pending=serial.write('A');serial.port={};await assert.rejects(pending,/отключена/);
});
test('settings sessions always restore button decoding after errors',async()=>{
  const serial=new PocketSerial();serial.port={};const written=[];
  serial.write=async text=>{written.push(text);if(text==='[Z')serial.text='#CFG\n';};
  serial.waitFor=async()=>{throw new Error('timeout');};
  await assert.rejects(serial.config('list'),/timeout/);
  assert.deepEqual(written,['[Z','list\n','bye\n',']0']);assert.equal(serial.session,false);
});

test('browser serial lifecycle streams, reads settings and releases both locks on disconnect',async()=>{
  const written=[],connections=[];let incoming,closed=0;
  const port={
    readable:new ReadableStream({start(controller){incoming=controller;}}),
    writable:new WritableStream({write(bytes){
      const command=new TextDecoder().decode(bytes);written.push(command);
      const reply=command==='Q'?'#SCR 115200\n':command==='[Z'?'#CFG\n':command==='list\n'?'opt 0 1 0|HDMI|On;Off\nend\n':'';
      if(reply)incoming.enqueue(new TextEncoder().encode(reply));
    }}),
    async open(config){assert.equal(config.baudRate,115200);},
    async close(){assert.equal(port.readable.locked,false);assert.equal(port.writable.locked,false);closed++;}
  };
  const serial=new PocketSerial({async requestPort(){return port;}});
  serial.addEventListener('connection',e=>connections.push(e.detail));
  try {
    await serial.connect();await serial.startScreen();assert.equal(serial.streaming,true);
    const opts=await serial.options();assert.equal(opts[0].label,'HDMI');assert.equal(serial.streaming,false);
    assert.ok(written.indexOf('v')<written.indexOf('[Z'));
    await serial.disconnect();assert.equal(serial.port,null);assert.equal(closed,1);
    assert.deepEqual(connections,[true,false]);assert.ok(written.includes(']0'));
  } finally { if(serial.port)await serial.disconnect(); }
});
