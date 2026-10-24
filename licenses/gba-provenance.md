# GBA imported source provenance

Only the following third-party GBA RTL files are imported in this change:

* `rtl/gba/cpu/gba_cpu.v`
* `rtl/gba/cpu/gba_cpu_thumbdecoder.v`

Source: https://github.com/nand2mario/gbatang at
`a8f9d182053a8108a7859c35613794cae9b72319`, `src/cpu/`, repository GPL-3.0.
The files retain attribution to risclite, nand2mario and Ruslan Lepetenok.
The underlying risclite implementation is Apache-2.0 at
`fc17416644f6021e99c41e81faad1135609a3036`; its full license is included.
GBATang's full license is included alongside the project's existing GPL-3.0.
No separate license for ThumbDecoder is invented here; it is imported from
GBATang's GPL-licensed distribution with its original author notice intact.

Modification on 2026-10-21: `gba_cpu.v` fixes the upper byte slice in an odd-address
LDRH rotation, changing `[23:15]` to `[23:16]`. The original ROM tests this path.
Whitespace is normalized in both imported files; author notices are preserved.
Other GBA modules and the diagnostic program are new GPL-3.0-or-later code.

MiSTer GBA, Cult-of-GBA BIOS, mGBA suite and gba-tests were inspected but are not
imported. Existing GBC/HDMI/FatFs source and notices remain unchanged.
