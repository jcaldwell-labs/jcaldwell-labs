# termui - Shared Terminal UI Library
# Makefile for building static and shared libraries

# Compiler settings
CC ?= gcc
CFLAGS = -Wall -Wextra -Werror -pedantic -std=c99 -O2
CFLAGS += -I./include
CFLAGS += -fPIC

# Library name
LIB_NAME = termui
LIB_STATIC = lib$(LIB_NAME).a
LIB_SHARED = lib$(LIB_NAME).so

# Dependencies
LDFLAGS = -lncurses

# Directories
SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj

# Source files
SOURCES = $(wildcard $(SRC_DIR)/*.c)
OBJECTS = $(SOURCES:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# Default target
.PHONY: all
all: $(LIB_STATIC) $(LIB_SHARED)

# Create object directory
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Compile source files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Build static library
$(LIB_STATIC): $(OBJECTS)
	ar rcs $@ $^

# Build shared library
$(LIB_SHARED): $(OBJECTS)
	$(CC) -shared -o $@ $^ $(LDFLAGS)

# Clean build artifacts
.PHONY: clean
clean:
	rm -rf $(OBJ_DIR)
	rm -f $(LIB_STATIC) $(LIB_SHARED)

# Install (optional - for system-wide installation)
PREFIX ?= /usr/local
.PHONY: install
install: $(LIB_STATIC) $(LIB_SHARED)
	install -d $(PREFIX)/lib
	install -d $(PREFIX)/include
	install -m 644 $(LIB_STATIC) $(PREFIX)/lib/
	install -m 755 $(LIB_SHARED) $(PREFIX)/lib/
	install -m 644 $(INC_DIR)/termui.h $(PREFIX)/include/

# Uninstall
.PHONY: uninstall
uninstall:
	rm -f $(PREFIX)/lib/$(LIB_STATIC)
	rm -f $(PREFIX)/lib/$(LIB_SHARED)
	rm -f $(PREFIX)/include/termui.h

# Test build - compile a simple test program
.PHONY: test
test: $(LIB_STATIC)
	@echo "Building test program..."
	$(CC) -o test_termui tests/test_termui.c -I$(INC_DIR) -L. -l$(LIB_NAME) $(LDFLAGS)
	@echo "Test program built successfully. Run ./test_termui to test."

# Help
.PHONY: help
help:
	@echo "termui - Shared Terminal UI Library"
	@echo ""
	@echo "Targets:"
	@echo "  all       Build static and shared libraries (default)"
	@echo "  clean     Remove build artifacts"
	@echo "  install   Install to PREFIX (default: /usr/local)"
	@echo "  uninstall Remove installed files"
	@echo "  test      Build and run test program"
	@echo "  help      Show this help"
	@echo ""
	@echo "Variables:"
	@echo "  CC        C compiler (default: gcc)"
	@echo "  PREFIX    Installation prefix (default: /usr/local)"

# Dependencies
$(OBJ_DIR)/termui_core.o: $(SRC_DIR)/termui_core.c $(INC_DIR)/termui.h
$(OBJ_DIR)/termui_buffer.o: $(SRC_DIR)/termui_buffer.c $(INC_DIR)/termui.h
