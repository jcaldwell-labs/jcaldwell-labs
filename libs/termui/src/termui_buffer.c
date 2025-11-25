/*
 * termui - Frame Buffer Implementation
 *
 * Double-buffered rendering for flicker-free terminal output.
 */

#include "termui.h"
#include <ncurses.h>
#include <stdlib.h>
#include <string.h>

/* Frame buffer structure */
struct termui_buffer {
    int width;
    int height;
    char *chars;           /* Character data */
    termui_color_t *colors; /* Per-cell color */
};

termui_buffer_t* termui_buffer_create(int width, int height) {
    if (width <= 0 || height <= 0) {
        return NULL;
    }

    termui_buffer_t *buf = malloc(sizeof(termui_buffer_t));
    if (!buf) {
        return NULL;
    }

    buf->width = width;
    buf->height = height;

    size_t size = (size_t)width * (size_t)height;

    buf->chars = malloc(size);
    if (!buf->chars) {
        free(buf);
        return NULL;
    }

    buf->colors = malloc(size * sizeof(termui_color_t));
    if (!buf->colors) {
        free(buf->chars);
        free(buf);
        return NULL;
    }

    termui_buffer_clear(buf);
    return buf;
}

void termui_buffer_destroy(termui_buffer_t *buf) {
    if (buf) {
        free(buf->chars);
        free(buf->colors);
        free(buf);
    }
}

void termui_buffer_clear(termui_buffer_t *buf) {
    if (!buf) return;

    size_t size = (size_t)buf->width * (size_t)buf->height;
    memset(buf->chars, ' ', size);
    memset(buf->colors, TERMUI_COLOR_DEFAULT, size * sizeof(termui_color_t));
}

void termui_buffer_get_size(const termui_buffer_t *buf, int *width, int *height) {
    if (!buf) {
        if (width) *width = 0;
        if (height) *height = 0;
        return;
    }
    if (width) *width = buf->width;
    if (height) *height = buf->height;
}

void termui_buffer_draw_char(termui_buffer_t *buf, int x, int y, char c, termui_color_t color) {
    if (!buf) return;
    if (x < 0 || x >= buf->width || y < 0 || y >= buf->height) return;

    size_t index = (size_t)y * (size_t)buf->width + (size_t)x;
    buf->chars[index] = c;
    buf->colors[index] = color;
}

void termui_buffer_draw_string(termui_buffer_t *buf, int x, int y, const char *str, termui_color_t color) {
    if (!buf || !str) return;
    if (y < 0 || y >= buf->height) return;

    int i = 0;
    while (str[i] != '\0') {
        int px = x + i;
        if (px >= 0 && px < buf->width) {
            size_t index = (size_t)y * (size_t)buf->width + (size_t)px;
            buf->chars[index] = str[i];
            buf->colors[index] = color;
        }
        i++;
    }
}

void termui_buffer_draw_hline(termui_buffer_t *buf, int x, int y, int length, char c, termui_color_t color) {
    if (!buf || length <= 0) return;
    if (y < 0 || y >= buf->height) return;

    for (int i = 0; i < length; i++) {
        int px = x + i;
        if (px >= 0 && px < buf->width) {
            size_t index = (size_t)y * (size_t)buf->width + (size_t)px;
            buf->chars[index] = c;
            buf->colors[index] = color;
        }
    }
}

void termui_buffer_draw_vline(termui_buffer_t *buf, int x, int y, int length, char c, termui_color_t color) {
    if (!buf || length <= 0) return;
    if (x < 0 || x >= buf->width) return;

    for (int i = 0; i < length; i++) {
        int py = y + i;
        if (py >= 0 && py < buf->height) {
            size_t index = (size_t)py * (size_t)buf->width + (size_t)x;
            buf->chars[index] = c;
            buf->colors[index] = color;
        }
    }
}

void termui_buffer_draw_box(termui_buffer_t *buf, int x, int y, int width, int height, termui_color_t color) {
    if (!buf || width < 2 || height < 2) return;

    /* Top and bottom lines */
    termui_buffer_draw_hline(buf, x, y, width, '-', color);
    termui_buffer_draw_hline(buf, x, y + height - 1, width, '-', color);

    /* Left and right lines */
    termui_buffer_draw_vline(buf, x, y, height, '|', color);
    termui_buffer_draw_vline(buf, x + width - 1, y, height, '|', color);

    /* Corners */
    termui_buffer_draw_char(buf, x, y, '+', color);
    termui_buffer_draw_char(buf, x + width - 1, y, '+', color);
    termui_buffer_draw_char(buf, x, y + height - 1, '+', color);
    termui_buffer_draw_char(buf, x + width - 1, y + height - 1, '+', color);
}

void termui_buffer_render(const termui_buffer_t *buf) {
    if (!buf || !termui_is_initialized()) return;

    /* Move cursor to home */
    move(0, 0);

    /* Render each character with its color */
    for (int y = 0; y < buf->height; y++) {
        for (int x = 0; x < buf->width; x++) {
            size_t index = (size_t)y * (size_t)buf->width + (size_t)x;
            char ch = buf->chars[index];
            termui_color_t color = buf->colors[index];

            if (color > TERMUI_COLOR_DEFAULT && has_colors()) {
                attron(COLOR_PAIR(color));
                mvaddch(y, x, ch);
                attroff(COLOR_PAIR(color));
            } else {
                mvaddch(y, x, ch);
            }
        }
    }

    refresh();
}
