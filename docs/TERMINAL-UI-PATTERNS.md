# Terminal UI Patterns in jcaldwell-labs

This document catalogs common terminal UI patterns across C projects in the jcaldwell-labs organization.

**Date**: 2025-11-24
**Projects Analyzed**: terminal-stars, tario, boxes-live, adventure-engine-v2, smartterm-prototype

---

## Pattern Overview

| Pattern | terminal-stars | tario | boxes-live | smartterm-prototype |
|---------|---------------|-------|------------|---------------------|
| ncurses-based | Yes | No | Yes | Yes |
| Raw terminal (termios) | No | Yes | No | No |
| Frame buffer | Yes | Yes | No | Yes (output buffer) |
| Color support | Yes | Yes | Yes | Yes |
| Input abstraction | Yes | Inline | Yes | Yes |
| Resize handling | Yes | No | No | Yes |

---

## Pattern 1: Terminal Initialization

### ncurses Approach (terminal-stars, boxes-live, smartterm-prototype)

Common initialization sequence:

```c
int terminal_init(void) {
    // Initialize ncurses
    if (initscr() == NULL) {
        return -1;
    }

    // Configure terminal mode
    cbreak();              // Disable line buffering
    noecho();              // Don't echo typed characters
    keypad(stdscr, TRUE);  // Enable special keys (arrows, F-keys)
    nodelay(stdscr, TRUE); // Non-blocking input
    curs_set(0);           // Hide cursor

    // Initialize colors if available
    if (has_colors()) {
        start_color();
        use_default_colors();
        // Define color pairs...
    }

    return 0;
}
```

**Source Examples**:
- `terminal-stars/src/terminal.c:13-49`
- `boxes-live/src/terminal.c:33-87`
- `smartterm-prototype/lib/smartterm/smartterm_core.c:37-83`

### Raw Terminal Approach (tario)

Direct termios manipulation:

```c
int terminal_init(Terminal *term) {
    // Get original settings
    if (tcgetattr(STDIN_FILENO, &term->orig_termios) == -1) {
        return -1;
    }

    // Set up raw mode
    struct termios raw = term->orig_termios;
    raw.c_iflag &= ~(BRKINT | ICRNL | INPCK | ISTRIP | IXON);
    raw.c_oflag &= ~(OPOST);
    raw.c_cflag |= (CS8);
    raw.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);
    raw.c_cc[VMIN] = 0;
    raw.c_cc[VTIME] = 1;

    if (tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw) == -1) {
        return -1;
    }

    return 0;
}
```

**Source Example**: `tario/src/terminal.c:7-36`

---

## Pattern 2: Terminal Cleanup

### ncurses Cleanup

```c
void terminal_cleanup(void) {
    if (!isendwin()) {
        curs_set(1);  // Show cursor
        endwin();     // End ncurses mode
    }
}
```

**Source Example**: `terminal-stars/src/terminal.c:51-57`

### Raw Terminal Cleanup

```c
void terminal_restore(Terminal *term) {
    term_show_cursor();
    term_clear_screen();
    term_move_cursor(0, 0);
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &term->orig_termios);
}
```

**Source Example**: `tario/src/terminal.c:38-43`

---

## Pattern 3: Frame Buffer

Double-buffering prevents flicker and enables efficient rendering.

### Basic Structure

```c
typedef struct {
    int width;
    int height;
    char *buffer;      // Character data
    int *colors;       // Optional: per-cell color
} FrameBuffer;
```

### Operations

```c
// Create buffer
FrameBuffer* framebuffer_create(int width, int height) {
    FrameBuffer *fb = malloc(sizeof(FrameBuffer));
    fb->width = width;
    fb->height = height;
    fb->buffer = malloc(width * height);
    fb->colors = malloc(width * height * sizeof(int));
    framebuffer_clear(fb);
    return fb;
}

// Clear buffer
void framebuffer_clear(FrameBuffer *fb) {
    memset(fb->buffer, ' ', fb->width * fb->height);
    memset(fb->colors, 0, fb->width * fb->height * sizeof(int));
}

// Draw character at position
void framebuffer_draw_char(FrameBuffer *fb, int x, int y, char c, int color) {
    if (x >= 0 && x < fb->width && y >= 0 && y < fb->height) {
        int index = y * fb->width + x;
        fb->buffer[index] = c;
        fb->colors[index] = color;
    }
}

// Render to terminal
void framebuffer_display(const FrameBuffer *fb) {
    move(0, 0);
    for (int y = 0; y < fb->height; y++) {
        for (int x = 0; x < fb->width; x++) {
            int index = y * fb->width + x;
            if (fb->colors[index] > 0 && has_colors()) {
                attron(COLOR_PAIR(fb->colors[index]));
            }
            mvaddch(y, x, fb->buffer[index]);
            if (fb->colors[index] > 0 && has_colors()) {
                attroff(COLOR_PAIR(fb->colors[index]));
            }
        }
    }
    refresh();
}

// Cleanup
void framebuffer_destroy(FrameBuffer *fb) {
    free(fb->buffer);
    free(fb->colors);
    free(fb);
}
```

**Source Examples**:
- `terminal-stars/src/render.c:12-56` (with colors)
- `tario/src/render.c:7-62` (without colors)

---

## Pattern 4: Terminal Size Detection

### ncurses Approach

```c
void terminal_get_size(int *width, int *height) {
    getmaxyx(stdscr, *height, *width);
}
```

**Source Example**: `terminal-stars/src/terminal.c:59-63`

### ioctl Approach (POSIX)

```c
void terminal_get_size(Terminal *term) {
    struct winsize ws;
    if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == -1 || ws.ws_col == 0) {
        term->width = 80;   // Fallback
        term->height = 24;  // Fallback
    } else {
        term->width = ws.ws_col;
        term->height = ws.ws_row;
    }
}
```

**Source Example**: `tario/src/terminal.c:45-54`

---

## Pattern 5: Resize Handling

### Signal-Based (terminal-stars)

```c
static volatile sig_atomic_t resize_pending = 0;

static void handle_winch(int sig) {
    (void)sig;
    resize_pending = 1;
}

// In terminal_init():
struct sigaction sa;
sa.sa_handler = handle_winch;
sigemptyset(&sa.sa_mask);
sa.sa_flags = 0;
sigaction(SIGWINCH, &sa, NULL);

// In main loop:
void terminal_handle_resize(void) {
    if (resize_pending) {
        resize_pending = 0;
        endwin();
        refresh();
        clear();
    }
}
```

**Source Example**: `terminal-stars/src/terminal.c:6-72`

---

## Pattern 6: Input Handling

### Action-Based Input (terminal-stars)

```c
typedef enum {
    INPUT_NONE,
    INPUT_QUIT,
    INPUT_UP,
    INPUT_DOWN,
    INPUT_LEFT,
    INPUT_RIGHT,
    // ... more actions
} InputAction;

InputAction input_poll(void) {
    int ch = getch();

    if (ch == ERR) {
        return INPUT_NONE;
    }

    switch (ch) {
        case 27: // ESC
            return INPUT_QUIT;
        case KEY_UP:
        case 'w':
        case 'W':
            return INPUT_UP;
        // ... more mappings
        default:
            return INPUT_NONE;
    }
}
```

**Source Example**: `terminal-stars/src/input.c:11-92`

---

## Pattern 7: ANSI Escape Codes (Raw Terminal)

For projects not using ncurses:

```c
void term_clear_screen(void) {
    write(STDOUT_FILENO, "\x1b[2J", 4);  // Clear entire screen
    write(STDOUT_FILENO, "\x1b[H", 3);   // Move cursor to home
}

void term_move_cursor(int x, int y) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "\x1b[%d;%dH", y + 1, x + 1);
    write(STDOUT_FILENO, buf, len);
}

void term_hide_cursor(void) {
    write(STDOUT_FILENO, "\x1b[?25l", 6);
}

void term_show_cursor(void) {
    write(STDOUT_FILENO, "\x1b[?25h", 6);
}

void term_set_color(int fg, int bg) {
    char buf[32];
    int len = snprintf(buf, sizeof(buf), "\x1b[%d;%dm", fg + 30, bg + 40);
    write(STDOUT_FILENO, buf, len);
}

void term_reset_color(void) {
    write(STDOUT_FILENO, "\x1b[0m", 4);
}
```

**Source Example**: `tario/src/terminal.c:56-78`

---

## Pattern 8: Color Pairs (ncurses)

```c
// Initialize color pairs
if (has_colors()) {
    start_color();
    use_default_colors();

    init_pair(1, COLOR_WHITE, -1);    // White on default
    init_pair(2, COLOR_CYAN, -1);     // Cyan on default
    init_pair(3, COLOR_BLUE, -1);     // Blue on default
    init_pair(4, COLOR_YELLOW, -1);   // Yellow on default
    init_pair(5, COLOR_RED, -1);      // Red on default
    init_pair(6, COLOR_GREEN, -1);    // Green on default
    init_pair(7, COLOR_MAGENTA, -1);  // Magenta on default
}

// Use color pairs
attron(COLOR_PAIR(1));
mvaddch(y, x, character);
attroff(COLOR_PAIR(1));
```

**Source Examples**:
- `terminal-stars/src/terminal.c:27-39`
- `boxes-live/src/terminal.c:72-84`

---

## Recommendations for Shared Library

Based on this analysis, a shared `termui` library should provide:

### Core Components

1. **Terminal Context** - Unified initialization/cleanup
2. **Frame Buffer** - Character + optional color buffer
3. **Input Handler** - Action-based input polling
4. **Color Manager** - Color pair initialization and management

### API Design

```c
// Terminal lifecycle
termui_ctx* termui_init(const termui_config_t *config);
void termui_cleanup(termui_ctx *ctx);

// Frame buffer
termui_buffer* termui_buffer_create(int width, int height);
void termui_buffer_clear(termui_buffer *buf);
void termui_buffer_draw_char(termui_buffer *buf, int x, int y, char c, int color);
void termui_buffer_draw_string(termui_buffer *buf, int x, int y, const char *str, int color);
void termui_buffer_render(termui_buffer *buf);
void termui_buffer_destroy(termui_buffer *buf);

// Input
termui_action termui_input_poll(termui_ctx *ctx);

// Size
void termui_get_size(termui_ctx *ctx, int *width, int *height);
bool termui_check_resize(termui_ctx *ctx);
```

### Backend Options

Support both ncurses and raw terminal backends via compile-time flag:

```c
#ifdef TERMUI_USE_NCURSES
    // ncurses implementation
#else
    // Raw terminal implementation
#endif
```

---

## Next Steps

1. **PR 2**: Create `libs/termui/` with core components
2. **PR 3**: Update `tario` (simpler project) to use the library
3. **Future**: Migrate terminal-stars, boxes-live to shared library

---

## References

- [ncurses Programming HOWTO](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/)
- [ANSI Escape Codes](https://en.wikipedia.org/wiki/ANSI_escape_code)
- [termios Manual](https://man7.org/linux/man-pages/man3/termios.3.html)
