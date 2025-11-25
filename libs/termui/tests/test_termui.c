/*
 * termui - Simple Test Program
 *
 * Tests basic functionality of the termui library.
 */

#include "termui.h"
#include <stdio.h>
#include <unistd.h>

int main(void) {
    printf("termui v%s - Test Program\n", termui_version());
    printf("Initializing terminal...\n");

    /* Initialize with default config */
    if (termui_init(NULL) != TERMUI_OK) {
        fprintf(stderr, "Failed to initialize termui\n");
        return 1;
    }

    /* Get terminal size */
    int width, height;
    termui_get_size(&width, &height);

    /* Create frame buffer */
    termui_buffer_t *buf = termui_buffer_create(width, height);
    if (!buf) {
        fprintf(stderr, "Failed to create buffer\n");
        termui_cleanup();
        return 1;
    }

    /* Draw test pattern */
    termui_buffer_clear(buf);

    /* Draw border */
    termui_buffer_draw_box(buf, 0, 0, width, height, TERMUI_COLOR_CYAN);

    /* Draw title */
    const char *title = "termui Test - Press Q to quit";
    int title_x = (width - 30) / 2;
    termui_buffer_draw_string(buf, title_x, 1, title, TERMUI_COLOR_WHITE);

    /* Draw colored text samples */
    termui_buffer_draw_string(buf, 2, 3, "Colors:", TERMUI_COLOR_WHITE);
    termui_buffer_draw_string(buf, 2, 4, "WHITE", TERMUI_COLOR_WHITE);
    termui_buffer_draw_string(buf, 10, 4, "CYAN", TERMUI_COLOR_CYAN);
    termui_buffer_draw_string(buf, 17, 4, "BLUE", TERMUI_COLOR_BLUE);
    termui_buffer_draw_string(buf, 24, 4, "YELLOW", TERMUI_COLOR_YELLOW);
    termui_buffer_draw_string(buf, 33, 4, "RED", TERMUI_COLOR_RED);
    termui_buffer_draw_string(buf, 39, 4, "GREEN", TERMUI_COLOR_GREEN);
    termui_buffer_draw_string(buf, 47, 4, "MAGENTA", TERMUI_COLOR_MAGENTA);

    /* Draw info */
    char info[80];
    snprintf(info, sizeof(info), "Terminal size: %dx%d", width, height);
    termui_buffer_draw_string(buf, 2, 6, info, TERMUI_COLOR_CYAN);

    /* Draw box demo */
    termui_buffer_draw_string(buf, 2, 8, "Box drawing:", TERMUI_COLOR_WHITE);
    termui_buffer_draw_box(buf, 2, 9, 20, 5, TERMUI_COLOR_YELLOW);
    termui_buffer_draw_string(buf, 4, 11, "Inner content", TERMUI_COLOR_GREEN);

    /* Draw status line */
    termui_buffer_draw_string(buf, 2, height - 2, "Use arrow keys to test input, Q/ESC to quit", TERMUI_COLOR_CYAN);

    /* Render */
    termui_buffer_render(buf);

    /* Main loop - handle input */
    int running = 1;
    while (running) {
        termui_input_t input = termui_input_poll();

        switch (input) {
            case TERMUI_INPUT_QUIT:
                running = 0;
                break;

            case TERMUI_INPUT_UP:
                termui_buffer_draw_string(buf, 25, 9, "UP    ", TERMUI_COLOR_GREEN);
                termui_buffer_render(buf);
                break;

            case TERMUI_INPUT_DOWN:
                termui_buffer_draw_string(buf, 25, 9, "DOWN  ", TERMUI_COLOR_GREEN);
                termui_buffer_render(buf);
                break;

            case TERMUI_INPUT_LEFT:
                termui_buffer_draw_string(buf, 25, 9, "LEFT  ", TERMUI_COLOR_GREEN);
                termui_buffer_render(buf);
                break;

            case TERMUI_INPUT_RIGHT:
                termui_buffer_draw_string(buf, 25, 9, "RIGHT ", TERMUI_COLOR_GREEN);
                termui_buffer_render(buf);
                break;

            case TERMUI_INPUT_ACTION:
                termui_buffer_draw_string(buf, 25, 9, "ACTION", TERMUI_COLOR_YELLOW);
                termui_buffer_render(buf);
                break;

            case TERMUI_INPUT_RESIZE:
                /* Handle resize */
                termui_check_resize();
                termui_get_size(&width, &height);
                termui_buffer_destroy(buf);
                buf = termui_buffer_create(width, height);
                if (buf) {
                    termui_buffer_clear(buf);
                    termui_buffer_draw_string(buf, 2, 2, "Resized! Press Q to quit.", TERMUI_COLOR_WHITE);
                    termui_buffer_render(buf);
                }
                break;

            default:
                break;
        }

        /* Small delay to prevent busy-waiting */
        usleep(16000); /* ~60 FPS */
    }

    /* Cleanup */
    termui_buffer_destroy(buf);
    termui_cleanup();

    printf("Test complete!\n");
    return 0;
}
