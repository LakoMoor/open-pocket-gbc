"""Build the game image for the SPI flash (read by the menu firmware, fw/src/main.c).
usage: make_games.py out.bin rom1[=Name] [rom2[=Name] ...]   (max 15 games)
Flash it with: openFPGALoader -b tangnano20k --external-flash -o 0x200000 out.bin"""
import struct, sys, os

out, specs = sys.argv[1], sys.argv[2:]
assert 1 <= len(specs) <= 15, 'need 1..15 games'
entries, blobs = [], []
off = 0x1000                              # first ROM after the 4 KB directory block
for spec in specs:
    path, _, name = spec.partition('=')
    data = open(path, 'rb').read()
    if not name:
        name = data[0x134:0x143].split(b'\0')[0].decode('ascii', 'replace').strip() or os.path.basename(path)
    name = name.encode('ascii', 'replace')[:24]
    entries.append(struct.pack('<24sII', name.ljust(24, b'\0'), off, len(data)))
    blobs.append((off, data))
    off = (off + len(data) + 0xFFF) & ~0xFFF

img = bytearray(b'\xff' * off)
img[0:16] = b'GBCP' + bytes([len(specs)]) + b'\0' * 11
for i, e in enumerate(entries):
    img[16 + 32 * i:16 + 32 * (i + 1)] = e
for o, d in blobs:
    img[o:o + len(d)] = d
open(out, 'wb').write(img)
for e in entries:
    n, o, l = struct.unpack('<24sII', e)
    print(f'{n.rstrip(chr(0).encode()).decode():24s} offset 0x{o:06x} size {l}')
print(f'wrote {out}: {len(img)} bytes')
