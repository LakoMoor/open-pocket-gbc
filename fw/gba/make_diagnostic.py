#!/usr/bin/env python3
"""SPDX-License-Identifier: GPL-3.0-or-later
Assemble the small, original ARMv4T bring-up ROM without a cross compiler.
No Nintendo logo or BIOS. Not intended to boot on a retail GBA BIOS.
The instruction subset and literal/branch fixups are explicit below.
"""
from pathlib import Path
import struct

ROOT = Path(__file__).resolve().parents[2]
image = bytearray(1024)
def word(at, value): struct.pack_into('<I', image, at, value)
def half(at, value): struct.pack_into('<H', image, at, value)
word(0, 0xEA00002E)  # b 0x080000c0
image[0xa0:0xac] = b'OPENPOCKET  '
image[0xac:0xb0] = b'OPGB'
image[0xb2] = 0x96
image[0xbd] = (-sum(image[0xa0:0xbd]) - 0x19) & 255
arm = [0xe3a00003, 0xe3a01301, 0xe1c100b0,  # Mode 3, DISPCNT
       0xe3a04007, 0xe2944005, 0xe354000c,  # 7+5, CMP
       0x13a04000, 0xef000000,             # MOVNE skipped, SWI/return
       0xe3a03403, 0xe5834000,             # IWRAM[0] = 12
       (6,0x11223344), 0xe5836004,         # IWRAM[4] = test pattern
       0xe1d360b7, 0xe5836008,             # odd LDRH lane 3 -> IWRAM+8
       0xe3a06000, 0xe583600c,             # clear IRQ completion flag
       0xe3a03301, 0xe3a06008, 0xe5836200, # IE = timer0
       0xe3a06001, 0xe5836208,             # IME = 1
       (6,0x00c0fff0),0xe5836100,          # timer0 reload fff0, enable + IRQ
       0xe10f5000,0xe3c55080,0xe121f005,   # MRS/BIC/MSR: unmask CPSR IRQ
       0xe3a03403]                        # IWRAM base
wait = 0xc0 + len(arm)*4
arm += [0xe593600c,0xe3560001]             # wait for the real IRQ handler
at = 0xc0 + len(arm)*4
arm += [0x1a000000 | (((wait-at-8)//4)&0xffffff), (2,0x08000201),0xe12fff12]
pool = 0xc0 + len(arm)*4
for i, value in enumerate(arm):
    at = 0xc0+i*4
    if isinstance(value,tuple):
        reg, literal_value = value
        word(at,0xe59f0000 | reg<<12 | (pool-at-8))
        word(pool,literal_value);pool+=4
    else: word(at,value)
assert pool < 0x200
pc = 0x200
labels, fixups = {}, []
def emit(value):
    global pc
    half(pc, value); pc += 2
def literal(reg, value):
    fixups.append((pc, reg, value)); emit(0)
literal(0, 0x06000000)
literal(1, 0x001f)
literal(2, 38400)
labels['fill'] = pc
emit(0x8001)  # strh r1,[r0]
emit(0x3002)  # adds r0,#2
emit(0x3101)  # adds r1,#1 (RGB555 ramp)
emit(0x3a01)  # subs r2,#1
emit(0xd100 | (((labels['fill']-(pc+4))//2) & 255))
literal(0, 0x02000000)
literal(1, 0x12345678)
emit(0x6001)  # str r1,[r0] -- completion signature
emit(0xe7fe)  # b .
pc = (pc+3) & ~3
for at, reg, value in fixups:
    offset = pc - ((at+4) & ~3)
    assert offset % 4 == 0 and offset < 1024
    half(at, 0x4800 | reg << 8 | offset//4)
    word(pc, value); pc += 4
out = ROOT/'fw/gba/diagnostic.hex'
out.write_text(''.join(f'{value:08x}\n' for value, in struct.iter_unpack('<I', image)))
(ROOT/'build/gba').mkdir(parents=True, exist_ok=True)
(ROOT/'build/gba/diagnostic.gba').write_bytes(image)
print(f'{out}: {len(image)} bytes, ARM + Thumb, generated')
