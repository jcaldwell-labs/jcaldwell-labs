/*
 * Simple Visual Joystick Test
 * Clean, non-flashing display with radial direction line
 */

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <math.h>
#include <linux/input.h>
#include <sys/ioctl.h>

#define MAX_BUTTONS 16
#define GRID_SIZE 21

/* Simple radial line drawing */
void draw_stick_grid(int axis_x, int axis_y, const int *buttons) {
    /* Normalize to -1.0 to 1.0 */
    double nx = axis_x / 32768.0;
    double ny = axis_y / 32768.0;

    /* Apply deadzone */
    if (fabs(nx) < 0.15) nx = 0.0;
    if (fabs(ny) < 0.15) ny = 0.0;

    /* Map to grid (0 to GRID_SIZE-1) */
    int cx = GRID_SIZE / 2;
    int cy = GRID_SIZE / 2;
    int sx = cx + (int)(nx * (GRID_SIZE / 2 - 1));
    int sy = cy + (int)(ny * (GRID_SIZE / 2 - 1));

    /* Draw grid */
    printf("\n  LEFT STICK:\n");
    for (int y = 0; y < GRID_SIZE; y++) {
        printf("  ");
        for (int x = 0; x < GRID_SIZE; x++) {
            /* Calculate if this point is on the radial line */
            bool on_line = false;
            if (fabs(nx) > 0.0 || fabs(ny) > 0.0) {
                /* Check if point is on line from center to stick */
                double line_t = 0.0;
                if (fabs(nx) > fabs(ny)) {
                    /* Line more horizontal */
                    int line_x_range = sx - cx;
                    if (line_x_range != 0) {
                        line_t = (double)(x - cx) / line_x_range;
                    }
                } else {
                    /* Line more vertical */
                    int line_y_range = sy - cy;
                    if (line_y_range != 0) {
                        line_t = (double)(y - cy) / line_y_range;
                    }
                }

                if (line_t >= 0.0 && line_t <= 1.0) {
                    int line_x = cx + (int)(line_t * (sx - cx));
                    int line_y = cy + (int)(line_t * (sy - cy));
                    if (abs(x - line_x) <= 1 && abs(y - line_y) <= 1) {
                        on_line = true;
                    }
                }
            }

            /* Draw character */
            if (x == sx && y == sy) {
                printf("◉");  /* Stick position */
            } else if (x == cx && y == cy) {
                printf("+");  /* Center */
            } else if (on_line) {
                printf("·");  /* Radial line */
            } else if (x == cx) {
                printf("│");  /* Y-axis */
            } else if (y == cy) {
                printf("─");  /* X-axis */
            } else {
                printf(" ");
            }
        }
        printf("\n");
    }

    /* Axis info */
    printf("\n  X: %6d (% .2f)  Y: %6d (% .2f)\n", axis_x, nx, axis_y, ny);

    /* Direction */
    printf("  DIR: ");
    if (fabs(nx) < 0.15 && fabs(ny) < 0.15) {
        printf("CENTER");
    } else {
        if (ny < -0.3) {
            if (nx < -0.3) printf("UP-LEFT");
            else if (nx > 0.3) printf("UP-RIGHT");
            else printf("UP");
        } else if (ny > 0.3) {
            if (nx < -0.3) printf("DOWN-LEFT");
            else if (nx > 0.3) printf("DOWN-RIGHT");
            else printf("DOWN");
        } else {
            if (nx < -0.3) printf("LEFT");
            else printf("RIGHT");
        }
    }
    printf("\n\n");

    /* Buttons - Hyperkin layout */
    printf("  BUTTONS:\n");
    printf("  Fire: L");
    printf(buttons[4] || buttons[6] ? "[●]" : "[○]");
    printf("  R");
    printf(buttons[5] || buttons[7] ? "[●]" : "[○]");
    printf("  |  Face: A");
    printf(buttons[0] ? "[●]" : "[○]");
    printf(" B");
    printf(buttons[1] ? "[●]" : "[○]");
    printf(" X");
    printf(buttons[3] ? "[●]" : "[○]");
    printf(" Y");
    printf(buttons[2] ? "[●]" : "[○]");
    printf("  |  Sys: SEL");
    printf(buttons[8] ? "[●]" : "[○]");
    printf(" START");
    printf(buttons[9] ? "[●]" : "[○]");
    printf("\n\n");
}

int main(int argc, char *argv[]) {
    const char *device = "/dev/input/event0";
    if (argc > 1) device = argv[1];

    int fd = open(device, O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "Cannot open %s: %s\n", device, strerror(errno));
        fprintf(stderr, "Run: ./scripts/joystick-diagnostic.sh\n");
        return 1;
    }

    printf("\033[2J\033[H");  /* Clear screen once */
    printf("Joystick Test - %s\n", device);
    printf("Press Ctrl+C to quit\n");

    int axis[MAX_BUTTONS] = {0};
    int buttons[MAX_BUTTONS] = {0};
    int frame = 0;

    struct input_event ev;
    while (1) {
        ssize_t n = read(fd, &ev, sizeof(ev));

        if (n < 0) {
            if (errno == EAGAIN) {
                /* Redraw only every 15 frames (~250ms) to reduce flashing */
                if (frame++ % 15 == 0) {
                    printf("\033[H");  /* Home cursor, don't clear screen */
                    printf("Joystick Test - %s                    \n", device);
                    printf("Press Ctrl+C to quit                  \n");
                    draw_stick_grid(axis[0], axis[1], buttons);
                }

                struct timespec ts = {0, 16666667};
                nanosleep(&ts, NULL);
                continue;
            }
            break;
        }

        if (n != sizeof(ev)) continue;

        /* Update state */
        if (ev.type == EV_ABS) {
            if (ev.code == ABS_X) axis[0] = ev.value;
            else if (ev.code == ABS_Y) axis[1] = ev.value;

            /* Immediate redraw on movement */
            printf("\033[H");
            printf("Joystick Test - %s                    \n", device);
            printf("Press Ctrl+C to quit                  \n");
            draw_stick_grid(axis[0], axis[1], buttons);
        } else if (ev.type == EV_KEY) {
            int btn = -1;
            if (ev.code >= BTN_JOYSTICK) btn = ev.code - BTN_JOYSTICK;
            else if (ev.code >= BTN_GAMEPAD) btn = ev.code - BTN_GAMEPAD;

            if (btn >= 0 && btn < MAX_BUTTONS) {
                buttons[btn] = ev.value;

                /* Immediate redraw on button press */
                printf("\033[H");
                printf("Joystick Test - %s                    \n", device);
                printf("Press Ctrl+C to quit                  \n");
                draw_stick_grid(axis[0], axis[1], buttons);
            }
        }
    }

    printf("\033[2J\033[H");
    printf("Test complete\n");
    close(fd);
    return 0;
}
