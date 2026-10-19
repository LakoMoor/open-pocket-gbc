// Small formatting helpers and the UART log.
#include <stdarg.h>
#include "util.h"

static void putch_buf(char **p, char *end, char c) {
    if (*p < end) *(*p)++ = c;
}

int vsfmt(char *buf, int n, const char *f, va_list ap) {
    char *p = buf, *end = buf + n - 1;
    for (; *f; f++) {
        if (*f != '%') { putch_buf(&p, end, *f); continue; }
        f++;
        char pad = ' ';
        int width = 0, left = 0;
        if (*f == '-') { left = 1; f++; }
        if (*f == '0') { pad = '0'; f++; }
        while (*f >= '0' && *f <= '9') width = width * 10 + (*f++ - '0');
        char tmp[16];
        const char *s = tmp;
        int len = 0;
        switch (*f) {
        case 's': s = va_arg(ap, const char *); if (!s) s = "(null)"; while (s[len]) len++; break;
        case 'c': tmp[0] = (char)va_arg(ap, int); len = 1; break;
        case 'd': case 'u': case 'x': case 'X': {
            unsigned v; int neg = 0;
            if (*f == 'd') { int iv = va_arg(ap, int); if (iv < 0) { neg = 1; v = -iv; } else v = iv; }
            else v = va_arg(ap, unsigned);
            unsigned base = (*f == 'x' || *f == 'X') ? 16 : 10;
            char r[12]; int k = 0;
            do { unsigned d = v % base; r[k++] = d < 10 ? '0' + d : (*f == 'x' ? 'a' : 'A') + d - 10; v /= base; } while (v);
            if (neg) r[k++] = '-';
            while (k) tmp[len++] = r[--k];
            break;
        }
        case '%': tmp[0] = '%'; len = 1; break;
        default: tmp[0] = '?'; len = 1; break;
        }
        if (!left) for (int i = len; i < width; i++) putch_buf(&p, end, pad);
        for (int i = 0; i < len; i++) putch_buf(&p, end, s[i]);
        if (left) for (int i = len; i < width; i++) putch_buf(&p, end, ' ');
    }
    *p = 0;
    return p - buf;
}

int sfmt(char *buf, int n, const char *f, ...) {
    va_list ap;
    va_start(ap, f);
    int r = vsfmt(buf, n, f, ap);
    va_end(ap);
    return r;
}

void log_putc(char c) {
    if (c == '\n') UART_TX = '\r';
    UART_TX = (uint8_t)c;
}

void logf(const char *f, ...) {
    char b[160];
    va_list ap;
    va_start(ap, f);
    vsfmt(b, sizeof b, f, ap);
    va_end(ap);
    for (char *p = b; *p; p++) log_putc(*p);
}

void wait_ms(uint32_t t) {
    uint32_t end = ms_now() + t;
    while ((int32_t)(ms_now() - end) < 0) { REG_WAIT = end - ms_now(); (void)REG_WAIT; }
}
