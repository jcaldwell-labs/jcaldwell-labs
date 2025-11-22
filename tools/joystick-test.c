/*
 * Simple Joystick Test Utility
 * Tests joystick connectivity using Linux evdev interface
 * Supports both /dev/input/js* (joydev) and /dev/input/event* (evdev)
 */

#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <time.h>
#include <linux/input.h>
#include <sys/ioctl.h>

#define MAX_AXES 8
#define MAX_BUTTONS 16

int main(int argc, char *argv[]) {
    const char *device_path = "/dev/input/event0";  // Default to evdev

    if (argc > 1) {
        device_path = argv[1];
    }

    printf("========================================\n");
    printf("Joystick Test Utility\n");
    printf("========================================\n");
    printf("Device: %s\n", device_path);
    printf("Press Ctrl+C to quit\n\n");

    // Open device
    int fd = open(device_path, O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        fprintf(stderr, "ERROR: Cannot open %s\n", device_path);
        fprintf(stderr, "Reason: %s\n\n", strerror(errno));

        printf("Troubleshooting:\n");
        printf("  1. Check device exists: ls -la /dev/input/\n");
        printf("  2. Check permissions: ls -la %s\n", device_path);
        printf("  3. Add to input group: sudo usermod -a -G input $USER\n");
        printf("  4. Run diagnostic: ./scripts/joystick-diagnostic.sh\n");
        return 1;
    }

    printf("✓ Device opened successfully\n");

    // Get device name
    char name[256] = "Unknown";
    if (ioctl(fd, EVIOCGNAME(sizeof(name)), name) >= 0) {
        printf("✓ Device name: %s\n", name);
    }

    // Get device capabilities
    unsigned long evbit[EV_MAX/sizeof(long) + 1];
    memset(evbit, 0, sizeof(evbit));
    if (ioctl(fd, EVIOCGBIT(0, sizeof(evbit)), evbit) >= 0) {
        printf("✓ Device capabilities: ");
        if (evbit[0] & (1 << EV_KEY)) printf("Buttons ");
        if (evbit[0] & (1 << EV_ABS)) printf("Axes ");
        if (evbit[0] & (1 << EV_REL)) printf("Relative ");
        printf("\n");
    }

    printf("\n");
    printf("Waiting for joystick input...\n");
    printf("(Move sticks and press buttons)\n");
    printf("----------------------------------------\n");

    // Track button and axis state
    int axis_values[MAX_AXES] = {0};
    int button_states[MAX_BUTTONS] = {0};

    // Main event loop
    struct input_event ev;
    int event_count = 0;

    while (1) {
        ssize_t bytes = read(fd, &ev, sizeof(ev));

        if (bytes < 0) {
            if (errno == EAGAIN || errno == EWOULDBLOCK) {
                // No data available, sleep briefly
                struct timespec ts = {0, 10000000};  // 10ms
                nanosleep(&ts, NULL);
                continue;
            } else {
                fprintf(stderr, "\nERROR: Read failed: %s\n", strerror(errno));
                break;
            }
        }

        if (bytes != sizeof(ev)) {
            continue;  // Incomplete read
        }

        // Process event
        if (ev.type == EV_ABS) {
            // Absolute axis (joystick axes)
            if (ev.code < MAX_AXES) {
                axis_values[ev.code] = ev.value;
                event_count++;

                // Print every 10th event to avoid spam
                if (event_count % 10 == 0) {
                    printf("\r[Axis %d] Value: %-6d  ", ev.code, ev.value);
                    fflush(stdout);
                }
            }
        } else if (ev.type == EV_KEY) {
            // Button event
            if (ev.code >= BTN_JOYSTICK && ev.code < BTN_JOYSTICK + MAX_BUTTONS) {
                int button = ev.code - BTN_JOYSTICK;
                button_states[button] = ev.value;

                printf("\r[Button %d] %s          \n",
                       button, ev.value ? "PRESSED " : "RELEASED");
                fflush(stdout);
            } else if (ev.code >= BTN_GAMEPAD && ev.code < BTN_GAMEPAD + MAX_BUTTONS) {
                int button = ev.code - BTN_GAMEPAD;
                button_states[button] = ev.value;

                printf("\r[Gamepad Button %d] %s          \n",
                       button, ev.value ? "PRESSED " : "RELEASED");
                fflush(stdout);
            }
        } else if (ev.type == EV_SYN) {
            // Sync event (end of event frame)
            // Print current state summary every 60 events (~1 second at 60Hz)
            if (event_count % 60 == 0 && event_count > 0) {
                printf("\n[Summary] Axes: ");
                for (int i = 0; i < 6; i++) {
                    printf("%d:%d ", i, axis_values[i]);
                }
                printf(" | Buttons: ");
                for (int i = 0; i < 16; i++) {
                    if (button_states[i]) {
                        printf("%d ", i);
                    }
                }
                printf("\n");
            }
        }
    }

    close(fd);
    printf("\n\nTest complete.\n");
    return 0;
}
