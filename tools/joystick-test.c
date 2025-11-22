/*
 * Visual Joystick Test Utility
 * Tests joystick connectivity using Linux evdev interface with ASCII art display
 */

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <math.h>
#include <linux/input.h>
#include <sys/ioctl.h>

#define MAX_AXES 8
#define MAX_BUTTONS 16

/* Clear screen and move cursor to top */
void clear_screen() {
    printf("\033[2J\033[H");
}

/* Move cursor to position */
void move_cursor(int row, int col) {
    printf("\033[%d;%dH", row, col);
}

/* Render ASCII art joystick visualization */
void render_joystick_visual(int axis_x, int axis_y, const int *buttons) {
    /* Normalize axes to -1.0 to 1.0 range */
    double norm_x = axis_x / 32768.0;
    double norm_y = axis_y / 32768.0;

    /* Apply deadzone (15%) */
    if (fabs(norm_x) < 0.15) norm_x = 0.0;
    if (fabs(norm_y) < 0.15) norm_y = 0.0;

    /* Calculate position on 21x11 grid (10 units from center each direction) */
    int grid_width = 21;
    int grid_height = 11;
    int center_x = grid_width / 2;
    int center_y = grid_height / 2;

    int stick_x = center_x + (int)(norm_x * center_x);
    int stick_y = center_y + (int)(norm_y * center_y);

    /* Clamp to grid bounds */
    if (stick_x < 0) stick_x = 0;
    if (stick_x >= grid_width) stick_x = grid_width - 1;
    if (stick_y < 0) stick_y = 0;
    if (stick_y >= grid_height) stick_y = grid_height - 1;

    clear_screen();

    printf("╔════════════════════════════════════════════════════════════╗\n");
    printf("║           JOYSTICK TEST UTILITY (Press Ctrl+C to quit)   ║\n");
    printf("╚════════════════════════════════════════════════════════════╝\n");
    printf("\n");

    /* Draw joystick surface area */
    printf("  LEFT STICK POSITION:\n");
    printf("  ┌─────────────────────┐\n");

    for (int y = 0; y < grid_height; y++) {
        printf("  │");
        for (int x = 0; x < grid_width; x++) {
            if (x == stick_x && y == stick_y) {
                /* Stick position */
                printf("◉");
            } else if (x == center_x && y == center_y) {
                /* Center point */
                printf("┼");
            } else if (x == center_x) {
                /* Vertical axis */
                printf("│");
            } else if (y == center_y) {
                /* Horizontal axis */
                printf("─");
            } else {
                /* Empty space */
                printf(" ");
            }
        }
        printf("│");

        /* Add axis values on the side */
        if (y == 2) {
            printf("   X-Axis: %6d (%.2f)", axis_x, norm_x);
        } else if (y == 3) {
            printf("   Y-Axis: %6d (%.2f)", axis_y, norm_y);
        } else if (y == 5) {
            if (fabs(norm_x) < 0.15 && fabs(norm_y) < 0.15) {
                printf("   Status: CENTERED");
            } else {
                printf("   Status: MOVED");
            }
        }

        printf("\n");
    }

    printf("  └─────────────────────┘\n");
    printf("       ◉ = Stick position, ┼ = Center (deadzone: 15%%)\n");
    printf("\n");

    /* Draw direction indicator */
    printf("  DIRECTION: ");
    if (fabs(norm_x) < 0.15 && fabs(norm_y) < 0.15) {
        printf("CENTER\n");
    } else {
        if (norm_y < -0.5) printf("UP ");
        if (norm_y > 0.5) printf("DOWN ");
        if (norm_x < -0.5) printf("LEFT ");
        if (norm_x > 0.5) printf("RIGHT ");
        printf("\n");
    }
    printf("\n");

    /* Draw buttons as shapes */
    printf("  BUTTONS:\n");
    printf("  ┌─────────────────────────────────────────┐\n");
    printf("  │                                         │\n");

    /* Button layout: two rows of 4 buttons each */
    printf("  │  ");
    for (int b = 0; b < 8; b++) {
        if (buttons[b]) {
            printf("[●]");  /* Pressed - filled circle */
        } else {
            printf("[○]");  /* Released - empty circle */
        }
        printf(" ");

        if (b == 3) {
            printf(" │\n  │  ");
        }
    }
    printf(" │\n");

    printf("  │                                         │\n");

    /* Special buttons (Start, Select) */
    printf("  │  Start: ");
    if (buttons[9]) {
        printf("[●]");
    } else {
        printf("[○]");
    }
    printf("  Select: ");
    if (buttons[8]) {
        printf("[●]");
    } else {
        printf("[○]");
    }
    printf("              │\n");

    printf("  │                                         │\n");
    printf("  └─────────────────────────────────────────┘\n");
    printf("   [○] = Released   [●] = Pressed\n");
    printf("\n");

    /* Button legend */
    printf("  BUTTON MAPPING:\n");
    printf("    0=A(Right)  1=B(Bottom)  2=X(Top)  3=Y(Left)\n");
    printf("    4=L1  5=R1  6=L2  7=R2  8=Select  9=Start\n");
    printf("\n");

    /* Raw values for debugging */
    printf("  RAW VALUES:\n");
    printf("    Axis X (0): %-6d  |  Axis Y (1): %-6d\n", axis_x, axis_y);
    printf("    Deadzone: 15%% (±4915)  |  Range: -32768 to +32767\n");
}

int main(int argc, char *argv[]) {
    const char *device_path = "/dev/input/event0";

    if (argc > 1) {
        device_path = argv[1];
    }

    /* Open device */
    int fd = open(device_path, O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "ERROR: Cannot open %s\n", device_path);
        fprintf(stderr, "Reason: %s\n\n", strerror(errno));
        fprintf(stderr, "Troubleshooting:\n");
        fprintf(stderr, "  1. Check device exists: ls -la /dev/input/\n");
        fprintf(stderr, "  2. Check permissions: ls -la %s\n", device_path);
        fprintf(stderr, "  3. Add to input group: sudo usermod -a -G input $USER\n");
        fprintf(stderr, "  4. Run diagnostic: ./scripts/joystick-diagnostic.sh\n");
        return 1;
    }

    /* Get device name */
    char name[256] = "Unknown";
    ioctl(fd, EVIOCGNAME(sizeof(name)), name);

    /* Initial display */
    clear_screen();
    printf("Connecting to: %s\n", device_path);
    printf("Device: %s\n", name);
    printf("Initializing...\n");

    struct timespec ts = {0, 500000000};  /* 0.5 second */
    nanosleep(&ts, NULL);

    /* Track state */
    int axis_values[MAX_AXES] = {0};
    int button_states[MAX_BUTTONS] = {0};
    int updates = 0;

    /* Main event loop */
    struct input_event ev;

    while (1) {
        ssize_t bytes = read(fd, &ev, sizeof(ev));

        if (bytes < 0) {
            if (errno == EAGAIN || errno == EWOULDBLOCK) {
                /* No data available */

                /* Redraw every ~60ms (16.67ms * 4) even without input to show steady display */
                if (updates % 4 == 0) {
                    render_joystick_visual(axis_values[0], axis_values[1], button_states);
                }

                struct timespec sleep_ts = {0, 16666667};  /* ~60 FPS (16.667ms) */
                nanosleep(&sleep_ts, NULL);
                updates++;
                continue;
            } else {
                clear_screen();
                fprintf(stderr, "ERROR: Read failed: %s\n", strerror(errno));
                fprintf(stderr, "\nJoystick may have disconnected.\n");
                fprintf(stderr, "Check: ls -la /dev/input/event0\n");
                break;
            }
        }

        if (bytes != sizeof(ev)) {
            continue;
        }

        /* Process event */
        if (ev.type == EV_ABS) {
            /* Absolute axis (joystick axes) */
            if (ev.code < MAX_AXES) {
                axis_values[ev.code] = ev.value;
                render_joystick_visual(axis_values[0], axis_values[1], button_states);
            }
        } else if (ev.type == EV_KEY) {
            /* Button event */
            int button = -1;

            if (ev.code >= BTN_JOYSTICK && ev.code < BTN_JOYSTICK + MAX_BUTTONS) {
                button = ev.code - BTN_JOYSTICK;
            } else if (ev.code >= BTN_GAMEPAD && ev.code < BTN_GAMEPAD + MAX_BUTTONS) {
                button = ev.code - BTN_GAMEPAD;
            }

            if (button >= 0 && button < MAX_BUTTONS) {
                button_states[button] = ev.value;
                render_joystick_visual(axis_values[0], axis_values[1], button_states);
            }
        }
    }

    close(fd);
    clear_screen();
    printf("Test complete.\n");
    return 0;
}
