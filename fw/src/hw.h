// Hardware registers of the I/O system (rtl/sys/iosys.sv).
#pragma once
#include <stdint.h>
#include <stddef.h>

#define IO(o)       (*(volatile uint32_t *)(0x02000000u + (o)))
#define REG_ID      IO(0x00)
#define REG_IN      IO(0x04)   // inputs, see K_*
#define REG_MS      IO(0x08)   // milliseconds since start
#define REG_STAT    IO(0x0C)   // [0] GBC mode [1] double speed [2] cart RAM written (clears) [31:16] frames
#define SD_DATA     IO(0x10)   // write: send byte; read: last received byte
#define SD_WORD     IO(0x14)   // read: receive 4 bytes (little endian)
#define SD_CTRL     IO(0x18)   // [0] CS  [15:8] SCK half period - 1
#define FL_DATA     IO(0x20)
#define FL_WORD     IO(0x24)
#define FL_CTRL     IO(0x28)
#define CT_DATA     IO(0x50)   // external W25Qxx "cartridge" flash
#define CT_WORD     IO(0x54)
#define CT_CTRL     IO(0x58)
#define UART_TX     IO(0x30)
#define REG_WAIT    IO(0x34)   // write: timeout in ms; read: sleep until an input changes or timeout
#define REG_CTRL    IO(0x38)
#define REG_CFG     IO(0x3C)
#define IOCTL_ADDR  IO(0x40)
#define IOCTL_DATA  IO(0x44)

#define OSD_RAM     ((volatile uint16_t *)0x03000000u)
#define LCD_TXT     ((volatile uint16_t *)0x03100000u)   // {attr, char}

// REG_IN
#define K_B      (1u << 0)
#define K_Y      (1u << 1)
#define K_SEL    (1u << 2)
#define K_START  (1u << 3)
#define K_UP     (1u << 4)
#define K_DOWN   (1u << 5)
#define K_LEFT   (1u << 6)
#define K_RIGHT  (1u << 7)
#define K_A      (1u << 8)
#define K_X      (1u << 9)
#define K_L      (1u << 10)
#define K_R      (1u << 11)
#define K_S1     (1u << 12)
#define K_S2     (1u << 13)
#define K_UMENU  (1u << 14)
#define K_URESET (1u << 15)
#define K_PAD    0x0FFFu

// REG_CTRL
#define C_CORE_RST  (1u << 0)
#define C_PAUSE     (1u << 1)
#define C_DOWNLOAD  (1u << 2)
#define C_SYS_SHIFT 3
#define C_OSD       (1u << 5)
#define C_DIM       (1u << 6)
#define C_HDMI_OFF  (1u << 7)
#define C_LCD_OFF   (1u << 8)
#define C_LED       (1u << 9)

// SDRAM layout (byte addresses, the CPU sees SDRAM at 0)
#define ROM_BASE    0x000000u
#define ROM_MAX     0x600000u
#define CRAM_BASE   0x600000u

static inline volatile uint8_t *sdram(uint32_t a) {
    uintptr_t p = a;
    __asm__ volatile("" : "+r"(p));
    return (volatile uint8_t *)p;
}
static inline uint32_t ms_now(void) { return REG_MS; }
