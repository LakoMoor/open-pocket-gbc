#include "bmp.h"

static uint32_t u32(const uint8_t *p) {
    return (uint32_t)p[0] | (uint32_t)p[1] << 8 | (uint32_t)p[2] << 16 | (uint32_t)p[3] << 24;
}

int bmp_parse(const uint8_t h[54], uint32_t size, bmp_info_t *out) {
    uint32_t dib = u32(h + 14), offset = u32(h + 10);
    int32_t width = (int32_t)u32(h + 18), height = (int32_t)u32(h + 22);
    uint32_t bits = (uint32_t)h[28] | (uint32_t)h[29] << 8;
    if (size < 54 || h[0] != 'B' || h[1] != 'M' || dib < 40 || dib > size - 14 ||
        offset < 14 + dib || offset > size || h[26] != 1 || h[27] != 0 ||
        (bits != 24 && bits != 32) || u32(h + 30) != 0 ||
        width < 1 || width > 4096 || height == 0 || height < -4096 || height > 4096) return -1;
    uint32_t rows = height < 0 ? (uint32_t)-height : (uint32_t)height;
    uint32_t stride = ((uint32_t)width * (bits / 8) + 3) & ~3u;
    if ((uint64_t)offset + (uint64_t)stride * rows > size) return -1;
    out->width = (uint32_t)width; out->height = rows; out->offset = offset;
    out->stride = stride; out->bytes_per_pixel = (uint8_t)(bits / 8); out->top_down = height < 0;
    return 0;
}
