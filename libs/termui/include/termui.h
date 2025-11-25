/*
 * termui - Shared Terminal UI Library for jcaldwell-labs projects
 *
 * A minimal terminal UI library providing common patterns:
 * - Terminal initialization/cleanup (ncurses)
 * - Frame buffer for double-buffered rendering
 * - Input action polling
 * - Color pair management
 *
 * Usage:
 *   #include <termui.h>
 *
 *   int main(void) {
 *       if (termui_init(NULL) != TERMUI_OK) return 1;
 *
 *       termui_buffer_t *buf = termui_buffer_create(80, 24);
 *       termui_buffer_clear(buf);
 *       termui_buffer_draw_string(buf, 0, 0, "Hello!", TERMUI_COLOR_WHITE);
 *       termui_buffer_render(buf);
 *
 *       termui_cleanup();
 *       return 0;
 *   }
 */

#ifndef TERMUI_H
#define TERMUI_H

#include <stdbool.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Version */
#define TERMUI_VERSION_MAJOR 1
#define TERMUI_VERSION_MINOR 0
#define TERMUI_VERSION_PATCH 0
#define TERMUI_VERSION "1.0.0"

/* Error codes */
typedef enum {
    TERMUI_OK = 0,
    TERMUI_ERROR = -1,
    TERMUI_NOMEM = -2,
    TERMUI_INVALID = -3,
    TERMUI_NOTINIT = -4
} termui_error_t;

/* Standard colors */
typedef enum {
    TERMUI_COLOR_DEFAULT = 0,
    TERMUI_COLOR_WHITE = 1,
    TERMUI_COLOR_CYAN = 2,
    TERMUI_COLOR_BLUE = 3,
    TERMUI_COLOR_YELLOW = 4,
    TERMUI_COLOR_RED = 5,
    TERMUI_COLOR_GREEN = 6,
    TERMUI_COLOR_MAGENTA = 7
} termui_color_t;

/* Input actions */
typedef enum {
    TERMUI_INPUT_NONE = 0,
    TERMUI_INPUT_QUIT,
    TERMUI_INPUT_UP,
    TERMUI_INPUT_DOWN,
    TERMUI_INPUT_LEFT,
    TERMUI_INPUT_RIGHT,
    TERMUI_INPUT_ACTION,      /* Space/Enter */
    TERMUI_INPUT_CANCEL,      /* ESC */
    TERMUI_INPUT_ZOOM_IN,
    TERMUI_INPUT_ZOOM_OUT,
    TERMUI_INPUT_RESIZE       /* Terminal resized */
} termui_input_t;

/* Configuration */
typedef struct {
    bool colors_enabled;      /* Enable color support (default: true) */
    bool mouse_enabled;       /* Enable mouse events (default: false) */
    bool raw_keys;            /* Don't translate keys (default: false) */
} termui_config_t;

/* Frame buffer - opaque type */
typedef struct termui_buffer termui_buffer_t;

/*
 * Core Functions
 */

/* Get default configuration */
termui_config_t termui_default_config(void);

/* Initialize terminal (call once at startup)
 * Pass NULL for default configuration */
int termui_init(const termui_config_t *config);

/* Cleanup terminal (call before exit) */
void termui_cleanup(void);

/* Check if library is initialized */
bool termui_is_initialized(void);

/* Get terminal size */
void termui_get_size(int *width, int *height);

/* Check and handle terminal resize
 * Returns true if terminal was resized */
bool termui_check_resize(void);

/* Get version string */
const char* termui_version(void);

/* Get error string for error code */
const char* termui_error_string(int code);

/*
 * Frame Buffer Functions
 */

/* Create a frame buffer with given dimensions */
termui_buffer_t* termui_buffer_create(int width, int height);

/* Destroy a frame buffer */
void termui_buffer_destroy(termui_buffer_t *buf);

/* Clear buffer to spaces */
void termui_buffer_clear(termui_buffer_t *buf);

/* Get buffer dimensions */
void termui_buffer_get_size(const termui_buffer_t *buf, int *width, int *height);

/* Draw a single character at position with color */
void termui_buffer_draw_char(termui_buffer_t *buf, int x, int y, char c, termui_color_t color);

/* Draw a string at position with color */
void termui_buffer_draw_string(termui_buffer_t *buf, int x, int y, const char *str, termui_color_t color);

/* Draw a horizontal line */
void termui_buffer_draw_hline(termui_buffer_t *buf, int x, int y, int length, char c, termui_color_t color);

/* Draw a vertical line */
void termui_buffer_draw_vline(termui_buffer_t *buf, int x, int y, int length, char c, termui_color_t color);

/* Draw a box outline */
void termui_buffer_draw_box(termui_buffer_t *buf, int x, int y, int width, int height, termui_color_t color);

/* Render buffer to terminal */
void termui_buffer_render(const termui_buffer_t *buf);

/*
 * Input Functions
 */

/* Poll for input (non-blocking)
 * Returns TERMUI_INPUT_NONE if no input available */
termui_input_t termui_input_poll(void);

/* Get raw key code from last poll
 * Only valid when raw_keys config is true */
int termui_input_raw_key(void);

#ifdef __cplusplus
}
#endif

#endif /* TERMUI_H */
