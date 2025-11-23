CC = gcc
CFLAGS = -Wall -Wextra -Werror -std=gnu99
LDFLAGS = -lm
TARGETS = joystick-test joystick-visualizer joystick-raw debug-joystick

all: $(TARGETS)

joystick-test: joystick-test.c
	$(CC) $(CFLAGS) -o joystick-test joystick-test.c $(LDFLAGS)

joystick-visualizer: joystick-visualizer.c
	$(CC) $(CFLAGS) -o joystick-visualizer joystick-visualizer.c $(LDFLAGS)

joystick-raw: joystick-raw.c
	$(CC) $(CFLAGS) -o joystick-raw joystick-raw.c $(LDFLAGS)

debug-joystick: debug-joystick.c
	$(CC) $(CFLAGS) -o debug-joystick debug-joystick.c $(LDFLAGS)

clean:
	rm -f $(TARGETS)

test: joystick-test
	@echo "Testing joystick connectivity..."
	@echo "Run: ./joystick-test /dev/input/event0"

.PHONY: all clean test
