#pragma once
#include <stdarg.h>
#include "hw.h"
int  vsfmt(char *buf, int n, const char *f, va_list ap);
int  sfmt(char *buf, int n, const char *f, ...);
void logf(const char *f, ...);
void wait_ms(uint32_t t);

// flash.c
void     flash_select(int chip);   // 0 on-board flash, 1 external cartridge flash
void     flash_init(void);
uint32_t flash_id(void);
uint32_t flash_size(uint32_t id);
void     flash_read(uint32_t addr, void *dst, uint32_t n);
void     flash_read_sdram(uint32_t addr, uint32_t dst, uint32_t n);
int      flash_write(uint32_t addr, const void *src, uint32_t n);   // erases 4 KB sectors as needed
int      flash_write_sdram(uint32_t addr, uint32_t src, uint32_t n);
int      flash_update_sdram(uint32_t addr, uint32_t src, uint32_t n);  // changed sectors only
void     flash_sleep(void);
int      flash_write_big(uint32_t addr, uint32_t src, uint32_t n, void (*progress)(uint32_t, uint32_t));
void     flash_erase_range(uint32_t addr, uint32_t n);

// sd.c
int      sd_init(void);        // 0 ok
int      sd_read(uint32_t lba, void *dst, uint32_t count);
int      sd_write(uint32_t lba, const void *src, uint32_t count);
uint32_t sd_sectors(void);
extern int sd_ok;
