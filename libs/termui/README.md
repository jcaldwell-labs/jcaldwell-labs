# termui

A minimal shared terminal UI library for jcaldwell-labs C projects.

## Features

- **Terminal Management**: Initialize/cleanup ncurses with sensible defaults
- **Frame Buffer**: Double-buffered rendering for flicker-free output
- **Input Handling**: Action-based input polling with WASD/arrow key mapping
- **Color Support**: Standard 8-color palette with ncurses color pairs
- **Resize Handling**: SIGWINCH signal handling for terminal resize events

## Quick Start

```c
#include <termui.h>

int main(void) {
    // Initialize terminal
    if (termui_init(NULL) != TERMUI_OK) {
        return 1;
    }

    // Get terminal size
    int width, height;
    termui_get_size(&width, &height);

    // Create frame buffer
    termui_buffer_t *buf = termui_buffer_create(width, height);

    // Draw something
    termui_buffer_clear(buf);
    termui_buffer_draw_string(buf, 0, 0, "Hello, termui!", TERMUI_COLOR_GREEN);
    termui_buffer_draw_box(buf, 5, 2, 20, 5, TERMUI_COLOR_CYAN);
    termui_buffer_render(buf);

    // Handle input
    while (1) {
        termui_input_t input = termui_input_poll();
        if (input == TERMUI_INPUT_QUIT) break;
    }

    // Cleanup
    termui_buffer_destroy(buf);
    termui_cleanup();
    return 0;
}
```

## Building

```bash
make        # Build static and shared libraries
make test   # Build and run test program
make clean  # Remove build artifacts
```

## Linking

### Static Library
```bash
gcc -o myapp myapp.c -I/path/to/termui/include -L/path/to/termui -ltermui -lncurses
```

### From jcaldwell-labs Project
```makefile
TERMUI_DIR = ../../libs/termui
CFLAGS += -I$(TERMUI_DIR)/include
LDFLAGS += -L$(TERMUI_DIR) -ltermui -lncurses
```

## API Reference

### Core Functions

| Function | Description |
|----------|-------------|
| `termui_init(config)` | Initialize terminal (pass NULL for defaults) |
| `termui_cleanup()` | Restore terminal and cleanup |
| `termui_get_size(w, h)` | Get current terminal dimensions |
| `termui_check_resize()` | Handle pending resize (returns true if resized) |

### Frame Buffer

| Function | Description |
|----------|-------------|
| `termui_buffer_create(w, h)` | Create frame buffer |
| `termui_buffer_destroy(buf)` | Free frame buffer |
| `termui_buffer_clear(buf)` | Clear to spaces |
| `termui_buffer_draw_char(buf, x, y, c, color)` | Draw single character |
| `termui_buffer_draw_string(buf, x, y, str, color)` | Draw string |
| `termui_buffer_draw_box(buf, x, y, w, h, color)` | Draw box outline |
| `termui_buffer_render(buf)` | Render to terminal |

### Input

| Function | Description |
|----------|-------------|
| `termui_input_poll()` | Poll for input (non-blocking) |
| `termui_input_raw_key()` | Get raw key code from last poll |

### Colors

```c
TERMUI_COLOR_DEFAULT  // No color
TERMUI_COLOR_WHITE
TERMUI_COLOR_CYAN
TERMUI_COLOR_BLUE
TERMUI_COLOR_YELLOW
TERMUI_COLOR_RED
TERMUI_COLOR_GREEN
TERMUI_COLOR_MAGENTA
```

### Input Actions

```c
TERMUI_INPUT_NONE     // No input
TERMUI_INPUT_QUIT     // Q or ESC
TERMUI_INPUT_UP       // W or Up arrow
TERMUI_INPUT_DOWN     // S or Down arrow
TERMUI_INPUT_LEFT     // A or Left arrow
TERMUI_INPUT_RIGHT    // D or Right arrow
TERMUI_INPUT_ACTION   // Space or Enter
TERMUI_INPUT_ZOOM_IN  // + or Z
TERMUI_INPUT_ZOOM_OUT // - or X
TERMUI_INPUT_RESIZE   // Terminal resized
```

## Dependencies

- ncurses library (`-lncurses`)
- POSIX signals (for resize handling)

## Projects Using termui

- (Proof of concept in progress)

## License

Part of jcaldwell-labs organization projects.
