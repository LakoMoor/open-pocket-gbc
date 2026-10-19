#!/usr/bin/env python3
"""Prints the menu firmware log (UART TX, 115200) for N seconds: python tools/fwlog.py [sec] [port]"""
import sys, time, serial

sec = float(sys.argv[1]) if len(sys.argv) > 1 else 10
port = sys.argv[2] if len(sys.argv) > 2 else "COM6"
s = serial.Serial(port, 115200, timeout=0.1)
end = time.time() + sec
while time.time() < end:
    b = s.read(256)
    if b:
        sys.stdout.write(b.decode("latin-1").replace("\r", ""))
        sys.stdout.flush()
