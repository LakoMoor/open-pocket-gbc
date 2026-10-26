#pragma once
#include <stdint.h>

typedef struct {
    uint32_t width, height, offset, stride;
    uint8_t bytes_per_pixel, top_down;
} bmp_info_t;

// Uncompressed Windows BMP, 24-bit BGR or 32-bit BGRX, up to 4096 x 4096.
int bmp_parse(const uint8_t header[54], uint32_t file_size, bmp_info_t *out);
