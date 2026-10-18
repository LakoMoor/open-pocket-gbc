#!/usr/bin/env python3
"""Remote control for Open Pocket GBC over the Tang Nano 20K USB-UART (rtl/io/uart_pad.sv).

  python tools/remote.py                      interactive: keys below, q quits
  python tools/remote.py "M . D D A . 2 M"    run a sequence

Interactive keys: arrows = d-pad, z = B, x = A, Enter = Start, Backspace = Select,
                  m = menu (S1), r = reset game (S2), q = quit
Sequence tokens:
  U D L R A B S(elect) T(start) M(enu) X(reset)   tap: press for --hold seconds, then release
  +K / -K                                         press / release K and keep it
  .                                               wait --gap seconds
  <number>                                        wait that many seconds (e.g. 2 or 0.5)
"""
import argparse
import sys
import time

import serial
import serial.tools.list_ports

BUTTONS = set('UDLRABSTMX')


def find_port():
    # The BL616 on the Tang Nano 20K enumerates as two interfaces: JTAG (WinUSB) and a CDC/FTDI UART.
    for p in serial.tools.list_ports.comports():
        if p.vid == 0x0403 and p.pid == 0x6010:
            return p.device
    ports = [p.device for p in serial.tools.list_ports.comports()]
    if len(ports) == 1:
        return ports[0]
    sys.exit('board UART not found, use --port (available: %s)' % ', '.join(ports))


class Pad:
    def __init__(self, port, hold, gap):
        self.s = serial.Serial(port, 115200, timeout=0)
        self.hold, self.gap = hold, gap
        self.s.write(b'0')

    def press(self, k):
        self.s.write(k.upper().encode())

    def release(self, k):
        self.s.write(k.lower().encode())

    def tap(self, k, hold=None):
        self.press(k)
        time.sleep(self.hold if hold is None else hold)
        self.release(k)
        time.sleep(self.gap)

    def run(self, seq):
        for tok in seq.split():
            if tok == '.':
                time.sleep(self.gap)
            elif tok[0] in '+-' and len(tok) == 2 and tok[1].upper() in BUTTONS:
                (self.press if tok[0] == '+' else self.release)(tok[1])
            elif tok.upper() in BUTTONS:
                self.tap(tok)
            else:
                time.sleep(float(tok))
        self.s.write(b'0')


def interactive(pad):
    import msvcrt   # Windows console
    keymap = {b'z': 'B', b'x': 'A', b'\r': 'T', b'\x08': 'S', b'm': 'M', b'r': 'X'}
    arrows = {b'H': 'U', b'P': 'D', b'K': 'L', b'M': 'R'}
    print('arrows = d-pad, z = B, x = A, Enter = Start, Backspace = Select, m = menu, r = reset, q = quit')
    while True:
        c = msvcrt.getch()
        if c == b'q':
            break
        if c in (b'\xe0', b'\x00'):
            k = arrows.get(msvcrt.getch())
        else:
            k = keymap.get(c.lower())
        if k:
            pad.tap(k, 0.12)
    pad.s.write(b'0')


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('seq', nargs='?', help='button sequence (default: interactive)')
    ap.add_argument('--port', help='serial port (default: auto)')
    ap.add_argument('--hold', type=float, default=0.12, help='tap length in seconds')
    ap.add_argument('--gap', type=float, default=0.35, help='pause after a tap / for "."')
    a = ap.parse_args()
    pad = Pad(a.port or find_port(), a.hold, a.gap)
    if a.seq:
        pad.run(a.seq)
    else:
        interactive(pad)


if __name__ == '__main__':
    main()
