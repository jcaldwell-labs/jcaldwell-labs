CC = gcc
CFLAGS = -Wall -Wextra -Werror -std=gnu99
TARGETS = joystick-test

all: $(TARGETS)

joystick-test: joystick-test.c
	$(CC) $(CFLAGS) -o joystick-test joystick-test.c

clean:
	rm -f $(TARGETS)

test: joystick-test
	@echo "Testing joystick connectivity..."
	@echo "Run: ./joystick-test /dev/input/event0"

.PHONY: all clean test
