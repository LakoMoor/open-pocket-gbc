// USB stream framing shared by the browser and the protocol tests. No DOM dependencies.
export class StreamParser {
  constructor(packet, text = () => {}) { this.packet = packet; this.text = text; this.reset(); }
  reset() { this.state = 'text'; this.line = ''; this.payload = []; this.words = 0; }
  feed(bytes) {
    for (const b of bytes) {
      switch (this.state) {
        case 'text':
          if (b === 0) { this.flushText(); this.state = 'type'; }
          else { this.line += String.fromCharCode(b); if (b === 10 || this.line.length >= 1024) this.flushText(); }
          break;
        case 'type':
          this.type = String.fromCharCode(b); this.payload = [];
          this.state = this.type === 'R' ? 'row' : 'low'; break;
        case 'low': this.length = b; this.state = 'high'; break;
        case 'high':
          this.length |= b << 8;
          if (this.length > 4096) { this.reset(); break; }
          this.state = 'payload'; if (!this.length) this.emit(); break;
        case 'payload': this.payload.push(b); if (this.payload.length === this.length) this.emit(); break;
        case 'row':
          if (b >= 144) { this.reset(); break; }
          this.payload = [b]; this.words = 0; this.state = 'control'; break;
        case 'control':
          this.payload.push(b); this.run = b < 128 ? b + 1 : b - 126;
          if (this.words + this.run > 80) { this.reset(); break; }
          this.words += this.run; this.remaining = b < 128 ? this.run * 4 : 4; this.state = 'pixels'; break;
        case 'pixels':
          this.payload.push(b);
          if (--this.remaining === 0) { if (this.words === 80) this.emit(); else this.state = 'control'; }
          break;
      }
    }
  }
  flushText() { if (this.line) { this.text(this.line); this.line = ''; } }
  emit() { this.packet(this.type, Uint8Array.from(this.payload)); this.state = 'text'; this.payload = []; }
}

export function decodeRow(type, bytes) {
  if (!bytes.length || bytes[0] >= 144 || !['G', 'R'].includes(type)) return null;
  const pixels = new Uint16Array(160), unit = type === 'R' ? 4 : 2;
  let at = 1, x = 0;
  while (at < bytes.length && x < 160) {
    const c = bytes[at++], count = c < 128 ? c + 1 : c - 126;
    const units = c < 128 ? count : 1;
    if (at + units * unit > bytes.length || x + count * unit / 2 > 160) return null;
    for (let n = 0; n < count; n++) {
      const p = at + (c < 128 ? n * unit : 0);
      pixels[x++] = bytes[p] | bytes[p + 1] << 8;
      if (unit === 4) pixels[x++] = bytes[p + 2] | bytes[p + 3] << 8;
    }
    at += units * unit;
  }
  return x === 160 && at === bytes.length ? { y: bytes[0], pixels } : null;
}

export function parseOptions(text) {
  return text.split(/\r?\n/).flatMap(line => {
    const m = line.match(/^opt (\d+) (\d+) (\d+)\|([^|]*)\|(.*)$/);
    return m ? [{ page: +m[1], item: +m[2], value: +m[3], label: m[4], choices: m[5].split(';') }] : [];
  });
}
