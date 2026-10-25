import { StreamParser, parseOptions } from './protocol.mjs';
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));

export class PocketSerial extends EventTarget {
  constructor(serial = globalThis.navigator?.serial) {
    super(); this.serial = serial; this.port = null; this.queue = Promise.resolve(); this.text = ''; this.streaming = false; this.session = false;
    this.parser = new StreamParser((type, data) => this.emit('packet', { type, data }), text => {
      this.text = (this.text + text).slice(-65536); this.emit('text', text);
    });
  }
  emit(name, detail) { this.dispatchEvent(new CustomEvent(name, { detail })); }
  async connect() {
    if (this.port || this.opening) return;
    this.opening = true;
    try {
      const port = await this.serial.requestPort({ filters: [{ usbVendorId: 0x0403, usbProductId: 0x6010 }] });
      await port.open({ baudRate: 115200, bufferSize: 65536 });
      this.port = port; this.parser.reset(); this.text = ''; this.queue = Promise.resolve();
      this.readTask = this.readLoop(port);
      await this.write(']0'); await sleep(50); await this.write('?');
      this.heartbeat = setInterval(() => { if (!this.session) this.write('~').catch(e => this.emit('error', e)); }, 500);
      this.emit('connection', true);
    } finally { this.opening = false; }
  }
  write(value) {
    const port = this.port;
    const task = this.queue.then(async () => {
      if (!port?.writable || port !== this.port) throw new Error('Плата отключена');
      const writer = port.writable.getWriter();
      try { await writer.write(new TextEncoder().encode(value)); } finally { writer.releaseLock(); }
    });
    this.queue = task.catch(() => {}); return task;
  }
  async readLoop(port) {
    const reader = port.readable.getReader(); this.reader = reader;
    try {
      while (true) { const { value, done } = await reader.read(); if (done) break; this.parser.feed(value); }
    } catch (e) { if (!this.closing) this.emit('error', e); }
    finally {
      reader.releaseLock(); if (this.reader === reader) this.reader = null;
      if (!this.closing) { this.cleanup(); this.port = null; await port.close().catch(() => {}); this.emit('connection', false); }
    }
  }
  cleanup() { clearInterval(this.heartbeat); this.streaming = false; this.session = false; }
  async disconnect() {
    if (!this.port || this.closing) return;
    this.closing = true;
    try {
      // Stop before closing, so the USB bridge never has an unread continuous stream.
      await this.write('v').catch(() => {}); await sleep(600); await this.write(']0').catch(() => {});
      this.cleanup(); await this.reader?.cancel(); await this.readTask; await this.queue;
      await this.port.close().catch(() => {});
    } finally { this.port = null; this.closing = false; this.emit('connection', false); }
  }
  async waitFor(test, timeout = 5000) {
    const start = Date.now();
    while (!test(this.text)) {
      if (!this.port) throw new Error('USB-соединение потеряно');
      if (Date.now() - start > timeout) throw new Error('Плата не ответила. Проверь порт и версию прошивки.');
      await sleep(20);
    }
    return this.text;
  }
  async startScreen() {
    if (this.session) throw new Error('Дождись завершения настройки');
    this.text = ''; await this.write('Q');
    await this.waitFor(t => /#SCR 115200/.test(t)); this.streaming = true;
  }
  async stopScreen() {
    await this.write('v'); this.streaming = false;
    // The firmware checks the stop byte between rows. Do not interleave a settings session.
    await sleep(600); await this.write('0');
  }
  async config(command) {
    if (this.session) throw new Error('Дождись предыдущего запроса');
    this.session = true;
    try {
      if (this.streaming) await this.stopScreen();
      this.text = '';
      const start = Date.now();
      while (!this.text.includes('#CFG\n') && !this.text.includes('#CFG\r\n')) {
        if (Date.now() - start > 5500) throw new Error('Настройки требуют прошивку 1.6+. Проверь, что выбран UART-порт платы.');
        await this.write('[Z'); await sleep(300);
      }
      this.text = ''; await this.write(command + '\n');
      const response = await this.waitFor(t => command === 'list' ? /^end\r?$/m.test(t) : /^(ok|err)\r?$/m.test(t));
      return response;
    } finally {
      // Brackets suppress button decoding during config on bitstream 1.9+.
      // Older bitstreams ignore them and remain compatible.
      if (this.port) { await this.write('bye\n').catch(() => {}); await sleep(100); await this.write(']0').catch(() => {}); }
      this.session = false;
    }
  }
  async options() { return parseOptions(await this.config('list')); }
  async setOption(option, value) {
    if (!Number.isInteger(value) || value < 0 || value >= option.choices.length) throw new Error('Недопустимое значение');
    if (!/^ok\r?$/m.test(await this.config(`set ${option.page} ${option.item} ${value}`))) throw new Error('Плата отклонила настройку');
  }
}
