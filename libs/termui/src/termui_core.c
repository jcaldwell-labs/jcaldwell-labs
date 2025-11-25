/*
 * termui - Core Implementation
 *
 * Terminal initialization, cleanup, and core utilities.
 */

/* Enable POSIX signals (sigaction, sigemptyset, etc.) */
#define _POSIX_C_SOURCE 200809L

#include "termui.h"
#include <ncurses.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>

/* Global state */
static bool g_initialized = false;
static termui_config_t g_config;
static volatile sig_atomic_t g_resize_pending = 0;
static int g_last_raw_key = 0;

/* Signal handler for SIGWINCH */
static void handle_winch(int sig) {
    (void)sig;
    g_resize_pending = 1;
}

termui_config_t termui_default_config(void) {
    termui_config_t config = {
        .colors_enabled = true,
        .mouse_enabled = false,
        .raw_keys = false
    };
    return config;
}

int termui_init(const termui_config_t *config) {
    if (g_initialized) {
        return TERMUI_OK;  /* Already initialized */
    }

    /* Store configuration */
    if (config) {
        g_config = *config;
    } else {
        g_config = termui_default_config();
    }

    /* Initialize ncurses */
    if (initscr() == NULL) {
        return TERMUI_ERROR;
    }

    /* Configure terminal mode */
    cbreak();              /* Disable line buffering */
    noecho();              /* Don't echo typed characters */
    keypad(stdscr, TRUE);  /* Enable special keys */
    nodelay(stdscr, TRUE); /* Non-blocking input */
    curs_set(0);           /* Hide cursor */

    /* Initialize colors if enabled and available */
    if (g_config.colors_enabled && has_colors()) {
        start_color();
        use_default_colors();

        /* Initialize standard color pairs */
        init_pair(TERMUI_COLOR_WHITE, COLOR_WHITE, -1);
        init_pair(TERMUI_COLOR_CYAN, COLOR_CYAN, -1);
        init_pair(TERMUI_COLOR_BLUE, COLOR_BLUE, -1);
        init_pair(TERMUI_COLOR_YELLOW, COLOR_YELLOW, -1);
        init_pair(TERMUI_COLOR_RED, COLOR_RED, -1);
        init_pair(TERMUI_COLOR_GREEN, COLOR_GREEN, -1);
        init_pair(TERMUI_COLOR_MAGENTA, COLOR_MAGENTA, -1);
    }

    /* Enable mouse if requested */
    if (g_config.mouse_enabled) {
#ifdef NCURSES_MOUSE_VERSION
        mousemask(ALL_MOUSE_EVENTS | REPORT_MOUSE_POSITION, NULL);
#endif
    }

    /* Set up resize signal handler */
    struct sigaction sa;
    sa.sa_handler = handle_winch;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sigaction(SIGWINCH, &sa, NULL);

    g_initialized = true;
    return TERMUI_OK;
}

void termui_cleanup(void) {
    if (!g_initialized) {
        return;
    }

    /* Restore terminal to normal mode */
    if (!isendwin()) {
        curs_set(1);  /* Show cursor */
        endwin();     /* End ncurses mode */
    }

    g_initialized = false;
}

bool termui_is_initialized(void) {
    return g_initialized;
}

void termui_get_size(int *width, int *height) {
    if (!g_initialized) {
        if (width) *width = 80;
        if (height) *height = 24;
        return;
    }

    int h, w;
    getmaxyx(stdscr, h, w);
    if (width) *width = w;
    if (height) *height = h;
}

bool termui_check_resize(void) {
    if (!g_initialized || !g_resize_pending) {
        return false;
    }

    g_resize_pending = 0;
    endwin();
    refresh();
    clear();
    return true;
}

const char* termui_version(void) {
    return TERMUI_VERSION;
}

const char* termui_error_string(int code) {
    switch (code) {
        case TERMUI_OK:      return "Success";
        case TERMUI_ERROR:   return "Generic error";
        case TERMUI_NOMEM:   return "Out of memory";
        case TERMUI_INVALID: return "Invalid argument";
        case TERMUI_NOTINIT: return "Not initialized";
        default:             return "Unknown error";
    }
}

/* Input polling implementation */
termui_input_t termui_input_poll(void) {
    if (!g_initialized) {
        return TERMUI_INPUT_NONE;
    }

    /* Check for resize first */
    if (g_resize_pending) {
        return TERMUI_INPUT_RESIZE;
    }

    int ch = getch();
    g_last_raw_key = ch;

    if (ch == ERR) {
        return TERMUI_INPUT_NONE;
    }

    /* If raw keys mode, let caller handle mapping */
    if (g_config.raw_keys) {
        return TERMUI_INPUT_NONE;  /* Caller should check termui_input_raw_key() */
    }

    /* Map keys to actions */
    switch (ch) {
        case 27: /* ESC */
        case 'q':
        case 'Q':
            return TERMUI_INPUT_QUIT;

        case KEY_UP:
        case 'w':
        case 'W':
            return TERMUI_INPUT_UP;

        case KEY_DOWN:
        case 's':
        case 'S':
            return TERMUI_INPUT_DOWN;

        case KEY_LEFT:
        case 'a':
        case 'A':
            return TERMUI_INPUT_LEFT;

        case KEY_RIGHT:
        case 'd':
        case 'D':
            return TERMUI_INPUT_RIGHT;

        case ' ':
        case '\n':
        case KEY_ENTER:
            return TERMUI_INPUT_ACTION;

        case '+':
        case '=':
        case 'z':
        case 'Z':
            return TERMUI_INPUT_ZOOM_IN;

        case '-':
        case '_':
        case 'x':
        case 'X':
            return TERMUI_INPUT_ZOOM_OUT;

        default:
            return TERMUI_INPUT_NONE;
    }
}

int termui_input_raw_key(void) {
    return g_last_raw_key;
}
