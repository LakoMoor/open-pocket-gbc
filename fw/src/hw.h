// Hardware registers of the I/O system (rtl/sys/iosys.sv).
#pragma once
#include <stdint.h>
#include <stddef.h>

#define IO(o)       (*(volatile uint32_t *)(0x02000000u + (o)))
#define REG_ID      IO(0x00)
#define REG_IN      IO(0x04)   // inputs, see K_*
#define REG_MS      IO(0x08)   // milliseconds since start
#define REG_STAT    IO(0x0C)   // [0] GBC mode [1] double speed [2] cart RAM written (clears) [4:3] newest framebuffer
                               // [5] a byte came over the USB-UART (clears) [31:16] frames
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
#define REG_DEEPWAIT IO(0x48)  // like REG_WAIT, and the SDRAM self-refreshes meanwhile (core paused)
#define REG_SE      IO(0x6C)   // stream engine (REG_ID version >= 2): write {fix row, fb word address} starts; read waits, rows sent
#define REG_SE_HTAB IO(0x70)   // write: word address of the engine's 144-word hash table
#define REG_AUD     IO(0x74)   // USB audio (REG_ID bit 2): write [0] on; read [14:8] samples waiting, [7:0] the oldest (taken)
#define REG_UART    IO(0x68)   // read: [11] byte received (clears) [7:0] the byte; write: [11:0] bit time in clocks (TX and RX)
#define REG_GPIO    IO(0x64)   // write: [0] SCL low [1] SDA low [2] I2C on (pins 15/16); read: [0] SCL [1] SDA [2] USB power
#define REG_PRN     IO(0x60)   // read [8] ready [7:0] byte (clears); write [7:0] reply two bytes on, [8] flush
#define REG_BEEP    IO(0x4C)   // menu sound: [11:0] half period in 4 us steps, [27:16] ms; a change starts it

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
#define C_SDRAM_PD  (1u << 10)  // SDRAM power-down between accesses
#define C_LCD_SLOW  (1u << 11)  // LCD ~30 fps
#define C_FAST      (1u << 12)  // fast forward (core at double speed)
#define C_FB_FORCE  (1u << 13)  // framebuffer writes with HDMI off (screenshots)
#define C_LINK      (1u << 14)  // link port pins active
#define C_PRINTER   (1u << 15)  // link port is a Game Boy Printer (REG_PRN), the core is cut off
#define C_PRN_VIRT  (1u << 16)  // virtual printer: the core's serial port talks to REG_PRN
#define C_LED_SHIFT 17          // [18:17] what the LEDs show: status, CPU clock, sound, activity
#define C_BT        (1u << 19)  // ZS-040 / HC-05 Bluetooth serial module on the link pins (42 RX, 56 TX)
#define C_IMAGE     (1u << 20)  // CPU picture stream to LCD; framebuffer shown as raw GBC RGB on HDMI
#define REG_IMAGE   IO(0x78)    // write [14:0] RGB555 pixel, [15] first pixel in 160x144 frame

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
