#!/usr/bin/env python3
"""Draws a "die shot" of the placed design: every used LUT, flip-flop, block RAM and I/O
of the GW2AR-18 at its real position from nextpnr (build/<top>/pnr.json), coloured by
the block it belongs to, with the routed wires as thin traces.

    python tools/die_shot.py [build/gbc_top/pnr.json] [docs/img/die.png]
"""
import json, re, sys, random
from PIL import Image, ImageDraw, ImageFont, ImageFilter

pnr = sys.argv[1] if len(sys.argv) > 1 else "build/gbc_top/pnr.json"
out = sys.argv[2] if len(sys.argv) > 2 else "docs/img/die.png"

# hierarchy prefix -> (label, colour); first match wins
GROUPS = [
    ("u_gb.cpu",        "Game Boy CPU (SM83)",       (232, 120,  60)),
    ("u_gb.video",      "PPU (video)",               ( 70, 170, 235)),
    ("u_gb.gbc_snd",    "APU (sound)",               (240, 200,  70)),
    ("u_gb.audio",      "APU (sound)",               (240, 200,  70)),
    ("u_gb.timer",      "Game Boy CPU (SM83)",       (232, 120,  60)),
    ("u_gb.hdma",       "DMA",                       (190, 110, 220)),
    ("u_gb.wram",       "WRAM / VRAM",               (120, 200, 120)),
    ("u_gb.vram",       "WRAM / VRAM",               (120, 200, 120)),
    ("u_gb.boot_rom",   "Boot ROM",                  (160, 160, 160)),
    ("u_gb",            "Game Boy glue",             (205, 140,  90)),
    ("u_cart",          "Cartridge mappers",         (225,  80, 110)),
    ("u_io.u_cpu",      "RISC-V menu CPU (FemtoRV32)",           ( 40, 220, 190)),
    ("u_io",            "I/O: SD, flash, OSD regs",  ( 30, 160, 150)),
    ("u_sdram",         "SDRAM controller",          (150, 120, 240)),
    ("u_mem",           "Framebuffer / line buffer", (110, 130, 230)),
    ("u_fbw",           "Framebuffer / line buffer", (110, 130, 230)),
    ("u_hdmi",          "HDMI encoder",              (250, 250, 250)),
    ("u_video",         "Scaler + OSD",              (130, 210, 250)),
    ("osd_ram",         "Scaler + OSD",              (130, 210, 250)),
    ("txt_ram",         "Scaler + OSD",              (130, 210, 250)),
    ("u_lcd",           "SPI LCD",                   (250, 150, 200)),
    ("u_audio",         "Audio out",                 (240, 220, 120)),
    ("u_ds2",           "Controllers",               (180, 230, 110)),
    ("u_uart_pad",      "Controllers",               (180, 230, 110)),
]
OTHER = ("Other logic", (150, 135, 120))

def group(name):
    n = name.lstrip("\\")
    for pre, label, col in GROUPS:
        if n.startswith(pre):
            return label, col
    return OTHER

d = json.load(open(pnr))
top = next(iter(d["modules"].values()))
cells = top["cells"]

S = 16                      # pixels per tile
bel_re = re.compile(r"X(\d+)Y(\d+)/(\S+)")
placed = []
maxx = maxy = 0
for name, c in cells.items():
    bel = c.get("attributes", {}).get("NEXTPNR_BEL")
    if not bel:
        continue
    m = bel_re.match(bel)
    if not m:
        continue
    x, y, b = int(m.group(1)), int(m.group(2)), m.group(3)
    maxx, maxy = max(maxx, x), max(maxy, y)
    placed.append((x, y, b, c["type"], name))

W, H = (maxx + 1) * S, (maxy + 1) * S
pad, legend_w = 40, 330
img = Image.new("RGB", (W + 2 * pad + legend_w, H + 2 * pad + 60), (18, 14, 12))
dr = ImageDraw.Draw(img, "RGBA")

# die substrate with a faint tile grid
dr.rectangle([pad - 12, pad - 12, pad + W + 12, pad + H + 12], fill=(54, 40, 30), outline=(120, 95, 70), width=3)
for x in range(maxx + 1):
    for y in range(maxy + 1):
        dr.rectangle([pad + x * S + 1, pad + y * S + 1, pad + x * S + S - 2, pad + y * S + S - 2], fill=(64, 48, 36))

# routed wires: connect the tiles each net passes through
wire_re = re.compile(r"X(\d+)Y(\d+)/")
rnd = random.Random(1)
for nname, net in top.get("netnames", {}).items():
    r = net.get("attributes", {}).get("ROUTING")
    if not r:
        continue
    pts = [(int(a), int(b)) for a, b in wire_re.findall(r)]
    if len(pts) < 2:
        continue
    lab, col = group(nname)
    seen = []
    for p in pts:
        if not seen or seen[-1] != p:
            seen.append(p)
    for (x0, y0), (x1, y1) in zip(seen, seen[1:]):
        if abs(x0 - x1) + abs(y0 - y1) > 12:
            continue
        j = rnd.randint(2, S - 3)
        dr.line([pad + x0 * S + j, pad + y0 * S + j, pad + x1 * S + j, pad + y1 * S + j],
                fill=(200, 160, 110, 22), width=1)

# cells
offs = {}
counts = {}
for x, y, b, t, name in placed:
    lab, col = group(name)
    counts[lab] = counts.get(lab, 0) + (1 if t.startswith("LUT") else 0)
    k = (x, y)
    i = offs.get(k, 0)
    offs[k] = i + 1
    px, py = pad + x * S, pad + y * S
    if "BSRAM" in b or t in ("SP", "SPX9", "DP", "DPB", "DPX9B", "SDPB", "SDPX9B", "pROM", "pROMX9"):
        dr.rectangle([px - 1, py - 1, px + 3 * S - 2, py + S - 2], fill=col + (235,), outline=(255, 255, 255, 60))
        for k2 in range(6):
            dr.line([px + 2, py + 2 + k2 * 2, px + 3 * S - 5, py + 2 + k2 * 2], fill=(0, 0, 0, 70))
    elif t.startswith("LUT") or t.startswith("ALU") or t.startswith("MUX") or t.startswith("RAM16"):
        sx, sy = i % 4, (i // 4) % 4
        dr.rectangle([px + 1 + sx * 3, py + 1 + sy * 3, px + 3 + sx * 3, py + 3 + sy * 3], fill=col + (220,))
    elif t.startswith("DFF"):
        sx, sy = i % 4, (i // 4) % 4
        dr.point([px + 2 + sx * 3, py + 2 + sy * 3], fill=(255, 255, 255, 120))
    elif t in ("IBUF", "OBUF", "IOBUF", "TBUF", "TLVDS_OBUF", "ELVDS_OBUF", "OSER10", "IOLOGIC"):
        dr.rectangle([px + 2, py + 2, px + S - 3, py + S - 3], fill=(230, 200, 120), outline=(255, 240, 180))
    elif t in ("rPLL", "PLLVR", "CLKDIV"):
        dr.rectangle([px - 2, py - 2, px + 2 * S, py + 2 * S], fill=(200, 200, 210), outline=(255, 255, 255))

img = img.filter(ImageFilter.GaussianBlur(0.35))
dr = ImageDraw.Draw(img, "RGBA")
try:
    font = ImageFont.truetype("arial.ttf", 16)
    big = ImageFont.truetype("arialbd.ttf", 22)
    tag = ImageFont.truetype("arialbd.ttf", 15)
except OSError:
    font = big = tag = ImageFont.load_default()

# block names at the centre of their logic, like the labels on a die photo
sums = {}
for x, y, b, t, name in placed:
    if not (t.startswith("LUT") or t.startswith("ALU")):
        continue
    lab, col = group(name)
    sx, sy, n = sums.get(lab, (0, 0, 0))
    sums[lab] = (sx + x, sy + y, n + 1)
SHORT = {"Game Boy CPU (SM83)": "SM83 CPU", "PPU (video)": "PPU", "APU (sound)": "APU",
         "RISC-V menu CPU (FemtoRV32)": "RISC-V", "Cartridge mappers": "MBC", "HDMI encoder": "HDMI",
         "SDRAM controller": "SDRAM ctl", "SPI LCD": "LCD", "Scaler + OSD": "Scaler/OSD",
         "I/O: SD, flash, OSD regs": "I/O", "Framebuffer / line buffer": "Framebuffer"}
for lab, (sx, sy, n) in sums.items():
    if n < 120 or lab not in SHORT:
        continue
    cx, cy = pad + sx / n * S + S / 2, pad + sy / n * S + S / 2
    text = SHORT[lab]
    w = dr.textlength(text, font=tag)
    dr.rounded_rectangle([cx - w / 2 - 6, cy - 11, cx + w / 2 + 6, cy + 11], radius=5, fill=(0, 0, 0, 170))
    dr.text((cx - w / 2, cy - 9), text, fill=(255, 245, 225), font=tag)
dr.text((pad, H + pad + 22), "GW2AR-18 (Tang Nano 20K): Open Pocket GBC as placed by nextpnr", fill=(230, 210, 180), font=big)

# legend, biggest blocks first
lx, ly = W + 2 * pad, pad
dr.text((lx, ly), "Blocks (LUTs)", fill=(230, 210, 180), font=big)
ly += 34
labels = {}
for pre, lab, col in GROUPS + [("", OTHER[0], OTHER[1])]:
    labels.setdefault(lab, col)
for lab, col in sorted(labels.items(), key=lambda kv: -counts.get(kv[0], 0)):
    if counts.get(lab, 0) == 0 and lab not in ("Boot ROM", "WRAM / VRAM"):
        continue
    dr.rectangle([lx, ly + 3, lx + 16, ly + 19], fill=col)
    dr.text((lx + 26, ly), "%s  %d" % (lab, counts.get(lab, 0)), fill=(225, 215, 200), font=font)
    ly += 26
img.save(out)
print("wrote", out, img.size, "cells", len(placed))
