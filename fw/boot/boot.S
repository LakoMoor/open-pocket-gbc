# Boot ROM (0x01000000): copies the firmware from SPI flash 0x100000 to SDRAM 0x780000.
# Flash image: u32 length in bytes, then the code; the code is copied and started at 0x780000.
    .section .text
    .globl _start
_start:
    li   a0, 0x02000000
    li   t0, 1                  # flash CS, SCK = clk/2
    sw   t0, 0x28(a0)
    li   t0, 0x03               # READ
    sw   t0, 0x20(a0)
    li   t0, 0x10               # address 0x100000
    sw   t0, 0x20(a0)
    sw   zero, 0x20(a0)
    sw   zero, 0x20(a0)
    lw   a2, 0x24(a0)           # length
    li   a1, 0x780000
    add  a2, a2, a1
1:  lw   t0, 0x24(a0)
    sw   t0, 0(a1)
    addi a1, a1, 4
    bltu a1, a2, 1b
    sw   zero, 0x28(a0)         # CS off
    li   t0, 0x780000
    jr   t0
