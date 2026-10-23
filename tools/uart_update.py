#!/usr/bin/env python3
"""Installs the firmware or the bitstream over the USB-UART: no JTAG, no WinUSB driver.

  python tools/uart_update.py opgbc_fw.bin            firmware (fw/build/fw.bin)
  python tools/uart_update.py opgbc_fpga.bin --fpga   bitstream (tools/make_update.py)

Needs firmware 1.5 or newer running on the board. Protocol: docs/remote.md (Update over USB).
Requires `pip install pyserial`; the port is found by VID 0403 / PID 6010, or use --port.
"""
import argparse
import struct
import sys
import time

import serial
import serial.tools.list_ports

BLOCK = 4096


def find_port():
    ports = [p for p in serial.tools.list_ports.comports() if p.vid == 0x0403 and p.pid == 0x6010]
    # the second interface of the debugger is the UART
    ports.sort(key=lambda p: p.location or p.device)
    return ports[-1].device if ports else None


def wait_reply(s, timeout):
    t = time.time() + timeout
    while time.time() < t:
        b = s.read(1)
        if b in (b'K', b'R', b'E'):
            return b
    return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('file')
    ap.add_argument('--fpga', action='store_true', help='the file is a bitstream (opgbc_fpga.bin)')
    ap.add_argument('--port')
    a = ap.parse_args()
    data = open(a.file, 'rb').read()
    if not a.fpga and (len(data) < 8 or struct.unpack('<I', data[:4])[0] + 4 != len(data)):
        sys.exit('not a firmware file (fw.bin: u32 length, then the code); use --fpga for a bitstream')
    port = a.port or find_port()
    if not port:
        sys.exit('no board found (VID 0403, PID 6010)')

    s = serial.Serial(port, 115200, timeout=0.05, write_timeout=2)
    s.reset_input_buffer()
    rx = b''
    t = time.time()
    while b'#UPD ' not in rx:                 # the firmware keeps only the last byte: repeat 'Y'
        if time.time() - t > 12:              # after a restart the intro runs ~4 s first
            sys.exit('the board did not answer: it needs firmware 1.5 or newer')
        s.write(b'Y')
        time.sleep(0.3)
        rx += s.read(4000)
    # "#UPD 503676": the firmware's rate; the bridge gets the nearest round value (within 1 %)
    baud = int(rx.split(b'#UPD ', 1)[1].split()[0])
    time.sleep(0.05)
    s.baudrate = round(baud / 50000) * 50000
    s.reset_input_buffer()

    hdr = b'OPUP' + bytes([1 if a.fpga else 0]) + struct.pack('<I', len(data))
    for _ in range(6):
        s.write(hdr)
        r = wait_reply(s, 1.5)
        if r == b'K':
            break
        if r == b'E':
            sys.exit('the board refused the file')
    else:
        sys.exit('no answer to the header')

    t0 = time.time()
    for o in range(0, len(data), BLOCK):
        blk = data[o:o + BLOCK]
        for tries in range(8):
            s.write(blk + struct.pack('<H', sum(blk) & 0xFFFF))
            r = wait_reply(s, 3)
            if r == b'K':
                break
            if r == b'E' or r is None:
                sys.exit(f'transfer failed at {o:#x} ({r})')
            print(f'  block {o:#x}: resend')
        else:
            sys.exit(f'transfer failed at {o:#x}')
        done = o + len(blk)
        print(f'\rsent {done >> 10} / {len(data) >> 10} KB', end='', flush=True)
    print(f'  ({time.time() - t0:.1f} s)')

    s.baudrate = 115200                       # the firmware switches back 50 ms after the last 'K'
    s.timeout = 0.5
    rx = b''
    t = time.time()
    while time.time() - t < 120:
        rx += s.read(4000)
        if b'#UPD ok' in rx:
            print('written and verified' + (': switch the power off and on' if a.fpga else ': the firmware restarts'))
            return
        if b'#UPD fail' in rx:
            sys.exit('writing the flash failed: ' + rx.decode('latin1').split('#UPD fail', 1)[1].split('\n')[0])
    sys.exit('no result from the board')


if __name__ == '__main__':
    main()
