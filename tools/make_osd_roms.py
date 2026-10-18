"""Generate OSD ROM images:
   rtl/video/font8x8.hex   128 glyphs x 8 rows, MSB = leftmost pixel (from public-domain font8x8_basic)
   rtl/sys/osd_strings.hex 64 strings x 16 chars (ids must match rtl/sys/menu.sv)"""
import re

src = open('third_party/font8x8_basic.h').read()
rows = re.findall(r'\{([^{}]*)\}', src[src.index('font8x8_basic[128][8]'):])
glyphs = [[int(v, 16) for v in r.split(',')] for r in rows[:128]]
assert len(glyphs) == 128 and all(len(g) == 8 for g in glyphs)

def rev(b):
    return int('{:08b}'.format(b)[::-1], 2)

with open('rtl/video/font8x8.hex', 'w') as f:
    for g in glyphs:
        for b in g:
            f.write('%02x\n' % rev(b))

strings = {
    0:  ' OPEN POCKET GBC',
    1:  'Resume',
    2:  'Reset game',
    3:  'Load game',
    4:  'Display',
    5:  'Palette',
    6:  'Colors',
    7:  'LCD',
    8:  'System',
    9:  'Debug',
    13: 'Now playing:',
    10: 'A:OK  B:Back',
    11: ' Select a game',
    12: 'No games',
    14: 'Loading...',
    16: 'Sharp', 17: 'Grid', 18: 'Lines',
    19: 'Gray', 20: 'Green', 21: 'Pocket', 22: 'Light', 23: 'Amber',
    24: 'LCD', 25: 'Raw',
    26: 'Fit', 27: 'Crop',
    32: 'Auto', 33: 'GBC', 34: 'DMG',
    30: 'Off', 31: 'On',
}
assert all(len(v) <= 16 for v in strings.values())
with open('rtl/sys/osd_strings.hex', 'w') as f:
    for i in range(64):
        s = strings.get(i, '').ljust(16)[:16]
        for ch in s:
            f.write('%02x\n' % ord(ch))
print('font + strings written')
