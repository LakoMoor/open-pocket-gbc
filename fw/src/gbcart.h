#pragma once
#include <stdint.h>

// original cartridges through the shift-register cartridge reader (gbcart.c)
int      gbcart_probe(uint8_t hdr[0x50]);    // 1: a cartridge with a valid header; hdr = 0x100-0x14F
int      gbcart_read_rom(uint32_t sdram_dst, uint32_t size, void (*progress)(uint32_t, uint32_t));  // 1: global checksum ok
void     gbcart_read_ram(uint32_t sdram_dst, uint32_t n);
uint32_t gbcart_write_ram(uint32_t sdram_src, uint32_t n);   // changed bytes only
