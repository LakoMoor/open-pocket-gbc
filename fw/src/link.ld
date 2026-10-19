OUTPUT_ARCH(riscv)
ENTRY(_start)
MEMORY { RAM (rwx) : ORIGIN = 0x00780000, LENGTH = 0x70000 }
SECTIONS {
    .text : { KEEP(*(.text.start)) *(.text .text.*) } > RAM
    .rodata : { *(.rodata .rodata.* .srodata .srodata.*) } > RAM
    .data : { *(.data .data.* .sdata .sdata.*) } > RAM
    . = ALIGN(4);
    _image_end = .;
    .bss (NOLOAD) : { __bss_start = .; *(.bss .bss.* .sbss .sbss.* COMMON) . = ALIGN(4); __bss_end = .; } > RAM
}
