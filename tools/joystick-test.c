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

/* Draw stick grid with radial line using Bresenham's algorithm */
void draw_stick_grid(int axis_x, int axis_y, const int *buttons) {
    /* Normalize to -1.0 to 1.0 */
    double nx = axis_x / 32768.0;
    double ny = axis_y / 32768.0;

    /* Apply deadzone */
    if (fabs(nx) < 0.15) nx = 0.0;
    if (fabs(ny) < 0.15) ny = 0.0;

    /* Calculate positions */
    int cx = GRID_SIZE / 2;
    int cy = GRID_SIZE / 2;
    int sx = cx + (int)(nx * (GRID_SIZE / 2 - 1));
    int sy = cy + (int)(ny * (GRID_SIZE / 2 - 1));

    /* Create grid and mark line points using Bresenham */
    char grid[GRID_SIZE][GRID_SIZE];
    memset(grid, ' ', sizeof(grid));

    /* Draw axes first */
    for (int i = 0; i < GRID_SIZE; i++) {
        grid[cy][i] = '-';  /* Horizontal axis */
        grid[i][cx] = '|';  /* Vertical axis */
    }
    grid[cy][cx] = '+';  /* Center */

    /* Draw radial line if stick is moved */
    if (sx != cx || sy != cy) {
        int x0 = cx, y0 = cy;
        int x1 = sx, y1 = sy;
        int dx = abs(x1 - x0);
        int dy = abs(y1 - y0);
        int sx_step = x0 < x1 ? 1 : -1;
        int sy_step = y0 < y1 ? 1 : -1;
        int err = dx - dy;

        while (1) {
            /* Mark line point (but don't overwrite center or stick) */
            if (!(x0 == cx && y0 == cy) && !(x0 == sx && y0 == sy)) {
                grid[y0][x0] = '*';
            }

            if (x0 == x1 && y0 == y1) break;

            int e2 = 2 * err;
            if (e2 > -dy) {
                err -= dy;
                x0 += sx_step;
            }
            if (e2 < dx) {
                err += dx;
                y0 += sy_step;
            }
        }
    }

    /* Place stick marker */
    grid[sy][sx] = '@';

    /* Draw grid */
    printf("\n  LEFT STICK:\n");
    for (int y = 0; y < GRID_SIZE; y++) {
        printf("  ");
        for (int x = 0; x < GRID_SIZE; x++) {
            printf("%c", grid[y][x]);
        }
        printf("\n");
    }

    /* Info */
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
            else if (nx > 0.3) printf("RIGHT");
            else printf("CENTER");
        }
    }
    printf("\n\n");

    /* Buttons */
    printf("  BUTTONS: Fire L");
    printf(buttons[4] || buttons[6] ? "[●]" : "[○]");
    printf(" R");
    printf(buttons[5] || buttons[7] ? "[●]" : "[○]");
    printf(" | Face A");
    printf(buttons[0] ? "[●]" : "[○]");
    printf(" B");
    printf(buttons[1] ? "[●]" : "[○]");
    printf(" X");
    printf(buttons[3] ? "[●]" : "[○]");
    printf(" Y");
    printf(buttons[2] ? "[●]" : "[○]");
    printf(" | SEL");
    printf(buttons[8] ? "[●]" : "[○]");
    printf(" START");
    printf(buttons[9] ? "[●]" : "[○]");
    printf("\n");
    printf("  Legend: @ = Stick, + = Center, * = Direction line\n\n");
}

int main(int argc, char *argv[]) {
    const char *device = "/dev/input/event0";
    if (argc > 1) device = argv[1];

    int fd = open(device, O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "Cannot open %s: %s\n", device, strerror(errno));
        return 1;
    }

    printf("\033[2J\033[H");
    printf("Joystick Test - Press Ctrl+C to quit\n\n");

    int axis[2] = {0, 0};
    int buttons[MAX_BUTTONS] = {0};
    int frame = 0;

    struct input_event ev;
    while (1) {
        ssize_t n = read(fd, &ev, sizeof(ev));

        if (n < 0) {
            if (errno == EAGAIN) {
                /* Slow redraw to prevent flashing */
                if (frame++ % 30 == 0) {
                    printf("\033[3;1H");  /* Move to line 3 */
                    draw_stick_grid(axis[0], axis[1], buttons);
                }
                struct timespec ts = {0, 16666667};
                nanosleep(&ts, NULL);
                continue;
            }
            break;
        }

        if (n != sizeof(ev)) continue;

        bool updated = false;

        if (ev.type == EV_ABS) {
            if (ev.code == ABS_X) { axis[0] = ev.value; updated = true; }
            else if (ev.code == ABS_Y) { axis[1] = ev.value; updated = true; }
        } else if (ev.type == EV_KEY) {
            int btn = -1;
            if (ev.code >= BTN_JOYSTICK) btn = ev.code - BTN_JOYSTICK;
            else if (ev.code >= BTN_GAMEPAD) btn = ev.code - BTN_GAMEPAD;

            if (btn >= 0 && btn < MAX_BUTTONS) {
                buttons[btn] = ev.value;
                updated = true;
            }
        }

        /* Immediate update on input */
        if (updated) {
            printf("\033[3;1H");
            draw_stick_grid(axis[0], axis[1], buttons);
        }
    }

    printf("\033[2J\033[H");
    close(fd);
    return 0;
}
