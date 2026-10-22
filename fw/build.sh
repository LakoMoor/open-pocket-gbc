#!/usr/bin/env bash
# Builds the menu firmware: fw/build/fw.bin = u32 length + code, written to flash 0x100000.
set -euo pipefail
cd "$(dirname "$0")"
# the xPack RISC-V toolchain: E:/tools on the dev PC, otherwise riscv-none-elf-gcc from PATH
for d in /e/tools/rvgcc/xpack-riscv-none-elf-gcc-*/bin; do if [ -d "$d" ]; then export PATH="$d:$PATH"; fi; done
# python3 on macOS/Linux; on Windows python3 may be the Store stub, so fall back to python
PY=${PY:-python3}; "$PY" -c '' 2>/dev/null || PY=python
export PY
mkdir -p build
# the home screen ROM; home/home.gb is kept in git, so RGBDS is only needed to change it
if [ -x "${RGBDS:-/e/tools/rgbds}/rgbasm.exe" ] || command -v rgbasm >/dev/null; then bash home/build.sh; fi
CFLAGS="-march=rv32e -mabi=ilp32e -Os -ffreestanding -fno-delete-null-pointer-checks -ffunction-sections -fdata-sections -Wall -Wno-unused-function -Isrc -Ifatfs"
riscv-none-elf-gcc $CFLAGS -nostartfiles -T src/link.ld -Wl,--gc-sections -Wl,-Map,build/fw.map \
    -o build/fw.elf src/start.S src/home.S src/*.c fatfs/ff.c fatfs/ffunicode.c -lc -lgcc
riscv-none-elf-objcopy -O binary build/fw.elf build/code.bin
"$PY" - <<'PY'
import struct
c=open('build/code.bin','rb').read(); c+=b'\0'*(-len(c)%4)
open('build/fw.bin','wb').write(struct.pack('<I',len(c))+c)
print('firmware', len(c), 'bytes')
PY
