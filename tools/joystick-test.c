/*
 * Enhanced Visual Joystick Test Utility
 * Features: /usr/bin/boxes borders, radial direction line, Hyperkin layout
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
#define GRID_WIDTH 41
#define GRID_HEIGHT 21

/* ANSI escape codes */
#define CLEAR_SCREEN "\033[2J\033[H"
#define BOLD "\033[1m"
#define GREEN "\033[32m"
#define CYAN "\033[36m"
#define MAGENTA "\033[35m"
#define YELLOW "\033[33m"
#define RESET "\033[0m"

/* Draw a line from center to stick position (radial indicator) */
void draw_radial_line(char grid[GRID_HEIGHT][GRID_WIDTH],
                      int center_x, int center_y,
                      int stick_x, int stick_y) {
    /* Bresenham's line algorithm */
    int dx = abs(stick_x - center_x);
    int dy = abs(stick_y - center_y);
    int sx = (center_x < stick_x) ? 1 : -1;
    int sy = (center_y < stick_y) ? 1 : -1;
    int err = dx - dy;

    int x = center_x;
    int y = center_y;

    while (1) {
        /* Don't overwrite center or stick position */
        if ((x != center_x || y != center_y) && (x != stick_x || y != stick_y)) {
            if (x >= 0 && x < GRID_WIDTH && y >= 0 && y < GRID_HEIGHT) {
                /* Use different characters for line direction */
                if (abs(dx) > abs(dy) * 2) {
                    grid[y][x] = '-';  /* Mostly horizontal */
                } else if (abs(dy) > abs(dx) * 2) {
                    grid[y][x] = '|';  /* Mostly vertical */
                } else {
                    grid[y][x] = '/';  /* Diagonal */
                }
            }
        }

        if (x == stick_x && y == stick_y) break;

        int e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x += sx;
        }
        if (e2 < dx) {
            err += dx;
            y += sy;
        }
    }
}

/* Render enhanced ASCII art joystick visualization */
void render_joystick_visual(int axis_x, int axis_y, const int *buttons) {
    /* Normalize axes */
    double norm_x = axis_x / 32768.0;
    double norm_y = axis_y / 32768.0;

    /* Apply deadzone */
    double deadzone_x = norm_x;
    double deadzone_y = norm_y;
    if (fabs(norm_x) < 0.15) deadzone_x = 0.0;
    if (fabs(norm_y) < 0.15) deadzone_y = 0.0;

    /* Calculate stick position */
    int center_x = GRID_WIDTH / 2;
    int center_y = GRID_HEIGHT / 2;
    int stick_x = center_x + (int)(deadzone_x * (GRID_WIDTH / 2 - 1));
    int stick_y = center_y + (int)(deadzone_y * (GRID_HEIGHT / 2 - 1));

    /* Clamp */
    if (stick_x < 0) stick_x = 0;
    if (stick_x >= GRID_WIDTH) stick_x = GRID_WIDTH - 1;
    if (stick_y < 0) stick_y = 0;
    if (stick_y >= GRID_HEIGHT) stick_y = GRID_HEIGHT - 1;

    printf(CLEAR_SCREEN);

    /* Title */
    printf(BOLD CYAN);
    printf("╔════════════════════════════════════════════════════════════════════╗\n");
    printf("║     JOYSTICK TEST - Hyperkin Trooper V2 (Press Ctrl+C to quit)   ║\n");
    printf("╚════════════════════════════════════════════════════════════════════╝\n");
    printf(RESET "\n");

    /* Create grid for drawing */
    char grid[GRID_HEIGHT][GRID_WIDTH];

    /* Initialize grid with axes and background */
    for (int y = 0; y < GRID_HEIGHT; y++) {
        for (int x = 0; x < GRID_WIDTH; x++) {
            if (x == center_x && y == center_y) {
                grid[y][x] = '+';  /* Center */
            } else if (x == center_x) {
                grid[y][x] = '|';  /* Y-axis */
            } else if (y == center_y) {
                grid[y][x] = '-';  /* X-axis */
            } else {
                grid[y][x] = ' ';  /* Empty */
            }
        }
    }

    /* Draw radial line from center to stick (if moved) */
    if (fabs(deadzone_x) > 0.0 || fabs(deadzone_y) > 0.0) {
        draw_radial_line(grid, center_x, center_y, stick_x, stick_y);
    }

    /* Place stick position marker (overwrites radial line endpoint) */
    grid[stick_y][stick_x] = '@';

    /* Draw the grid with boxes border */
    printf("  " BOLD "LEFT STICK POSITION:" RESET "\n");

    /* Create content for /usr/bin/boxes */
    FILE *boxes_pipe = popen("boxes -d stone", "w");
    if (boxes_pipe) {
        for (int y = 0; y < GRID_HEIGHT; y++) {
            for (int x = 0; x < GRID_WIDTH; x++) {
                if (grid[y][x] == '@') {
                    fprintf(boxes_pipe, MAGENTA BOLD "@" RESET);
                } else if (grid[y][x] == '+') {
                    fprintf(boxes_pipe, YELLOW "+" RESET);
                } else if (grid[y][x] == '|' || grid[y][x] == '-') {
                    fprintf(boxes_pipe, CYAN "%c" RESET, grid[y][x]);
                } else if (grid[y][x] == '/') {
                    fprintf(boxes_pipe, GREEN "·" RESET);  /* Radial line */
                } else {
                    fprintf(boxes_pipe, "%c", grid[y][x]);
                }
            }
            fprintf(boxes_pipe, "\n");
        }
        pclose(boxes_pipe);
    } else {
        /* Fallback if boxes not available */
        printf("  ┌");
        for (int i = 0; i < GRID_WIDTH; i++) printf("─");
        printf("┐\n");

        for (int y = 0; y < GRID_HEIGHT; y++) {
            printf("  │");
            for (int x = 0; x < GRID_WIDTH; x++) {
                char ch = grid[y][x];
                if (ch == '@') {
                    printf(MAGENTA BOLD "@" RESET);
                } else if (ch == '+') {
                    printf(YELLOW "+" RESET);
                } else if (ch == '|' || ch == '-') {
                    printf(CYAN "%c" RESET, ch);
                } else if (ch == '/') {
                    printf(GREEN "·" RESET);
                } else {
                    printf("%c", ch);
                }
            }
            printf("│\n");
        }

        printf("  └");
        for (int i = 0; i < GRID_WIDTH; i++) printf("─");
        printf("┘\n");
    }

    printf("       " MAGENTA "@" RESET " = Stick  " YELLOW "+" RESET " = Center  "
           GREEN "·" RESET " = Direction  " CYAN "|─" RESET " = Axes\n\n");

    /* Axis values */
    printf("  " BOLD "AXIS VALUES:" RESET "\n");
    printf("    X-Axis: %6d  Normalized: % .2f  ", axis_x, norm_x);
    if (fabs(deadzone_x) > 0.0) {
        printf(GREEN "ACTIVE" RESET);
    } else {
        printf("(deadzone)");
    }
    printf("\n");

    printf("    Y-Axis: %6d  Normalized: % .2f  ", axis_y, norm_y);
    if (fabs(deadzone_y) > 0.0) {
        printf(GREEN "ACTIVE" RESET);
    } else {
        printf("(deadzone)");
    }
    printf("\n\n");

    /* Direction with 8-way support */
    printf("  " BOLD "DIRECTION: " RESET);
    if (fabs(deadzone_x) < 0.15 && fabs(deadzone_y) < 0.15) {
        printf("CENTER\n");
    } else {
        /* 8-way direction */
        if (deadzone_y < -0.3) {
            if (deadzone_x < -0.3) printf(BOLD "UP-LEFT" RESET);
            else if (deadzone_x > 0.3) printf(BOLD "UP-RIGHT" RESET);
            else printf(BOLD "UP" RESET);
        } else if (deadzone_y > 0.3) {
            if (deadzone_x < -0.3) printf(BOLD "DOWN-LEFT" RESET);
            else if (deadzone_x > 0.3) printf(BOLD "DOWN-RIGHT" RESET);
            else printf(BOLD "DOWN" RESET);
        } else {
            if (deadzone_x < -0.3) printf(BOLD "LEFT" RESET);
            else if (deadzone_x > 0.3) printf(BOLD "RIGHT" RESET);
        }
        printf("\n");
    }
    printf("\n");

    /* Hyperkin Trooper V2 specific layout */
    printf("  " BOLD "HYPERKIN TROOPER V2 CONTROLS:" RESET "\n");
    printf("  ┌─────────────────────────────────────────────────────────────┐\n");
    printf("  │                                                             │\n");

    /* Top surface - Fire buttons (L/R triggers as prominent buttons) */
    printf("  │  TOP SURFACE (Fire Buttons):                                │\n");
    printf("  │    Left Fire:  ");
    if (buttons[4] || buttons[6]) {  /* L1 or L2 */
        printf(BOLD GREEN "[●]" RESET);
    } else {
        printf("[○]");
    }
    printf("     Right Fire: ");
    if (buttons[5] || buttons[7]) {  /* R1 or R2 */
        printf(BOLD GREEN "[●]" RESET);
    } else {
        printf("[○]");
    }
    printf("                      │\n");
    printf("  │                                                             │\n");

    /* Face buttons (bottom of controller) */
    printf("  │  FACE BUTTONS (Bottom):                                     │\n");
    printf("  │         ");
    if (buttons[2]) printf(BOLD GREEN "[●]Y" RESET); else printf("[○]Y");  /* Top */
    printf("                                                 │\n");

    printf("  │     ");
    if (buttons[3]) printf(BOLD GREEN "[●]X" RESET); else printf("[○]X");  /* Left */
    printf("    ");
    if (buttons[0]) printf(BOLD GREEN "[●]A" RESET); else printf("[○]A");  /* Center/Right */
    printf("    ");
    if (buttons[1]) printf(BOLD GREEN "[●]B" RESET); else printf("[○]B");  /* Right/Bottom */
    printf("                                      │\n");

    printf("  │                                                             │\n");

    /* System buttons (forward/aft) */
    printf("  │  SYSTEM (Forward/Aft):                                      │\n");
    printf("  │    Select: ");
    if (buttons[8]) printf(BOLD GREEN "[●]" RESET); else printf("[○]");
    printf("     Start: ");
    if (buttons[9]) printf(BOLD GREEN "[●]" RESET); else printf("[○]");
    printf("                                   │\n");

    printf("  │                                                             │\n");
    printf("  └─────────────────────────────────────────────────────────────┘\n");
    printf("     " GREEN "[●]" RESET " = Pressed   [○] = Released\n\n");

    /* Button function mapping */
    printf("  " BOLD "SUGGESTED MAPPING FOR boxes-live:" RESET "\n");
    printf("    " CYAN "Navigation Mode:" RESET "\n");
    printf("      Left Fire (L):   Secondary action / Cycle selection\n");
    printf("      Right Fire (R):  Primary action / Create box\n");
    printf("      A (right face):  Zoom in\n");
    printf("      B (bottom face): Zoom out\n");
    printf("      Select:          Load canvas\n");
    printf("      Start:           Save canvas\n");
    printf("\n");
    printf("    " CYAN "Edit Mode:" RESET "\n");
    printf("      Left Fire:   Delete box\n");
    printf("      Right Fire:  Confirm / Enter parameter mode\n");
    printf("      A:           Cycle color\n");
    printf("      B:           Return to navigation\n");
    printf("\n");
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
        fprintf(stderr, "Run diagnostic: cd ~/projects/jcaldwell-labs && ./scripts/joystick-diagnostic.sh\n");
        return 1;
    }

    /* Get device name */
    char name[256] = "Unknown";
    ioctl(fd, EVIOCGNAME(sizeof(name)), name);

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
                /* Redraw periodically even without input */
                if (updates % 4 == 0) {
                    render_joystick_visual(axis_values[0], axis_values[1], button_states);
                }

                struct timespec sleep_ts = {0, 16666667};  /* ~60 FPS */
                nanosleep(&sleep_ts, NULL);
                updates++;
                continue;
            } else {
                printf(CLEAR_SCREEN);
                fprintf(stderr, "ERROR: Joystick disconnected\n");
                break;
            }
        }

        if (bytes != sizeof(ev)) continue;

        /* Process events */
        if (ev.type == EV_ABS) {
            if (ev.code == ABS_X) {
                axis_values[0] = ev.value;
                render_joystick_visual(axis_values[0], axis_values[1], button_states);
            } else if (ev.code == ABS_Y) {
                axis_values[1] = ev.value;
                render_joystick_visual(axis_values[0], axis_values[1], button_states);
            }
        } else if (ev.type == EV_KEY) {
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
    printf(CLEAR_SCREEN "Test complete.\n");
    return 0;
}
