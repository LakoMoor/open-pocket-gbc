"""Convert an srec_cat-style MIF (ADDR: b0 b1 ...;) into a $readmemh hex file."""
import re, sys

src, dst = sys.argv[1], sys.argv[2]
depth = 4096
mem = [0] * depth
for line in open(src):
    m = re.match(r'\s*([0-9A-Fa-f]+)\s*:\s*([0-9A-Fa-f ]+);', line)
    if not m:
        continue
    addr = int(m.group(1), 16)
    for i, b in enumerate(m.group(2).split()):
        mem[addr + i] = int(b, 16)
with open(dst, 'w') as f:
    f.write('\n'.join('%02x' % b for b in mem) + '\n')
print('wrote', dst, 'nonzero bytes:', sum(1 for b in mem if b))
