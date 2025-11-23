#!/bin/bash
# Joystick testing helper script

DEVICE="${1:-/dev/input/event0}"

echo "═══════════════════════════════════════════════════════════════════"
echo "                    Joystick Testing Suite"
echo "═══════════════════════════════════════════════════════════════════"
echo ""
echo "Available tools:"
echo "  1) joystick-visualizer - Interactive ASCII visualization + event log"
echo "  2) joystick-raw        - Raw event dump with full details"
echo "  3) joystick-test       - Simple visual test (original)"
echo "  4) debug-joystick      - Quick device check"
echo ""
echo "Device: $DEVICE"
echo ""

# Check if device exists
if [ ! -e "$DEVICE" ]; then
    echo "ERROR: Device $DEVICE not found!"
    echo ""
    echo "Available input devices:"
    ls -l /dev/input/event* 2>/dev/null || echo "  No event devices found"
    echo ""
    echo "Try reconnecting the joystick with: attach_joystick.ps1 (on Windows)"
    exit 1
fi

# Check permissions
if [ ! -r "$DEVICE" ]; then
    echo "ERROR: Cannot read $DEVICE (permission denied)"
    echo "You may need to run with sudo or add user to 'input' group"
    exit 1
fi

echo "Select a tool to run:"
read -p "Enter 1-4 (or q to quit): " choice

case $choice in
    1)
        echo ""
        echo "Starting VISUALIZER (Ctrl+C to quit)..."
        sleep 1
        ./joystick-visualizer "$DEVICE"
        ;;
    2)
        echo ""
        echo "Starting RAW DUMP (Ctrl+C to quit)..."
        sleep 1
        ./joystick-raw "$DEVICE"
        ;;
    3)
        echo ""
        echo "Starting SIMPLE TEST (Q to quit)..."
        sleep 1
        ./joystick-test "$DEVICE"
        ;;
    4)
        echo ""
        echo "Running QUICK DEBUG..."
        ./debug-joystick "$DEVICE"
        ;;
    q|Q)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
