#!/usr/bin/env bash
# Builds the menu firmware: fw/build/fw.bin = u32 length + code, written to flash 0x100000.
set -euo pipefail
cd "$(dirname "$0")"
export PATH=/e/tools/rvgcc/xpack-riscv-none-elf-gcc-15.2.0-1/bin:$PATH
mkdir -p build
CFLAGS="-march=rv32e -mabi=ilp32e -Os -ffreestanding -fno-delete-null-pointer-checks -ffunction-sections -fdata-sections -Wall -Wno-unused-function -Isrc -Ifatfs"
riscv-none-elf-gcc $CFLAGS -nostartfiles -T src/link.ld -Wl,--gc-sections -Wl,-Map,build/fw.map \
    -o build/fw.elf src/start.S src/*.c fatfs/ff.c fatfs/ffunicode.c -lc -lgcc
riscv-none-elf-objcopy -O binary build/fw.elf build/code.bin
python - <<'PY'
import struct
c=open('build/code.bin','rb').read(); c+=b'\0'*(-len(c)%4)
open('build/fw.bin','wb').write(struct.pack('<I',len(c))+c)
print('firmware', len(c), 'bytes')
PY
