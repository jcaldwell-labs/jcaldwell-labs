#!/bin/bash
# Joystick Diagnostic Tool for WSL/Linux
# Helps diagnose joystick connectivity issues

set -e

echo "=========================================="
echo "Joystick Diagnostic Tool"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Check USB devices
echo -e "${BLUE}[1/7] Checking USB devices...${NC}"
if command -v lsusb &> /dev/null; then
    JOYSTICK_USB=$(lsusb | grep -i "joystick\|gamepad\|controller\|trooper\|xbox\|playstation" || echo "")
    if [ -n "$JOYSTICK_USB" ]; then
        echo -e "${GREEN}✓ Joystick USB device found:${NC}"
        echo "  $JOYSTICK_USB"
    else
        echo -e "${YELLOW}⚠ No joystick USB device detected${NC}"
        echo "  All USB devices:"
        lsusb | sed 's/^/  /'
    fi
else
    echo -e "${YELLOW}⚠ lsusb not available${NC}"
fi
echo ""

# 2. Check /dev/input/js* devices (joydev interface)
echo -e "${BLUE}[2/7] Checking /dev/input/js* devices (joydev interface)...${NC}"
if ls /dev/input/js* &> /dev/null; then
    echo -e "${GREEN}✓ Joystick devices found:${NC}"
    ls -la /dev/input/js* | sed 's/^/  /'

    # Check permissions
    for js_dev in /dev/input/js*; do
        if [ -r "$js_dev" ]; then
            echo -e "${GREEN}  ✓ Can read $js_dev${NC}"
        else
            echo -e "${RED}  ✗ Cannot read $js_dev (permission issue)${NC}"
            echo -e "    ${YELLOW}Fix: sudo usermod -a -G input $USER${NC}"
            echo -e "    ${YELLOW}Then log out and log back in${NC}"
        fi
    done
else
    echo -e "${RED}✗ No /dev/input/js* devices found${NC}"
    echo -e "  ${YELLOW}This means joydev kernel module is not loaded${NC}"
    echo -e "  ${YELLOW}Checking alternative: evdev interface (/dev/input/event*)${NC}"
fi
echo ""

# 3. Check /dev/input/event* devices (evdev interface)
echo -e "${BLUE}[3/7] Checking /dev/input/event* devices (evdev interface)...${NC}"
if ls /dev/input/event* &> /dev/null; then
    echo -e "${GREEN}✓ Event devices found:${NC}"
    EVENT_COUNT=$(ls /dev/input/event* | wc -l)
    echo "  Total: $EVENT_COUNT device(s)"

    # Check which ones are joysticks
    if [ -f /proc/bus/input/devices ]; then
        echo -e "${GREEN}✓ Checking device types:${NC}"

        # Parse /proc/bus/input/devices for joysticks
        JOYSTICK_FOUND=false
        while IFS= read -r line; do
            if echo "$line" | grep -qi "joystick\|gamepad\|trooper"; then
                JOYSTICK_FOUND=true
                echo -e "${GREEN}  ✓ Found joystick device:${NC}"
            fi
            if [ "$JOYSTICK_FOUND" = true ]; then
                if echo "$line" | grep -q "^H: Handlers="; then
                    echo "    $line"
                    JOYSTICK_FOUND=false
                elif echo "$line" | grep -q "^N: Name="; then
                    echo "    $line"
                elif echo "$line" | grep -q "^I:"; then
                    echo ""
                    JOYSTICK_FOUND=false
                fi
            fi
        done < /proc/bus/input/devices
    fi

    # Check permissions
    READABLE_EVENTS=()
    for event_dev in /dev/input/event*; do
        if [ -r "$event_dev" ]; then
            READABLE_EVENTS+=("$event_dev")
        fi
    done

    if [ ${#READABLE_EVENTS[@]} -gt 0 ]; then
        echo -e "${GREEN}  ✓ Readable event devices: ${#READABLE_EVENTS[@]}${NC}"
    else
        echo -e "${RED}  ✗ No readable event devices (permission issue)${NC}"
        echo -e "    ${YELLOW}Fix: sudo usermod -a -G input $USER${NC}"
    fi
else
    echo -e "${RED}✗ No /dev/input/event* devices found${NC}"
fi
echo ""

# 4. Check kernel modules
echo -e "${BLUE}[4/7] Checking kernel modules...${NC}"
if lsmod | grep -q "usbhid"; then
    echo -e "${GREEN}✓ usbhid module loaded${NC}"
else
    echo -e "${RED}✗ usbhid module not loaded${NC}"
fi

if lsmod | grep -q "joydev"; then
    echo -e "${GREEN}✓ joydev module loaded (/dev/input/js* available)${NC}"
else
    echo -e "${YELLOW}⚠ joydev module not loaded (/dev/input/js* NOT available)${NC}"
    echo -e "  ${YELLOW}This is common in minimal kernels${NC}"
    echo -e "  ${YELLOW}Use evdev interface (/dev/input/event*) instead${NC}"
fi

if lsmod | grep -q "evdev"; then
    echo -e "${GREEN}✓ evdev module loaded (/dev/input/event* available)${NC}"
else
    echo -e "${YELLOW}⚠ evdev module not loaded${NC}"
fi
echo ""

# 5. Check user groups
echo -e "${BLUE}[5/7] Checking user permissions...${NC}"
if groups | grep -q "input"; then
    echo -e "${GREEN}✓ User is in 'input' group${NC}"
else
    echo -e "${YELLOW}⚠ User NOT in 'input' group${NC}"
    echo -e "  ${YELLOW}Fix: sudo usermod -a -G input $USER${NC}"
    echo -e "  ${YELLOW}Then log out and log back in${NC}"
fi
echo ""

# 6. WSL-specific checks
echo -e "${BLUE}[6/7] Checking WSL-specific configuration...${NC}"
if grep -qi "microsoft\|wsl" /proc/version 2>/dev/null; then
    echo -e "${GREEN}✓ Running in WSL${NC}"

    # Check if vhci_hcd is loaded (USB/IP)
    if lsmod | grep -q "vhci_hcd"; then
        echo -e "${GREEN}✓ vhci_hcd loaded (USB/IP working)${NC}"
    else
        echo -e "${RED}✗ vhci_hcd not loaded (USB passthrough broken)${NC}"
    fi

    # Check for usbipd
    echo -e "${YELLOW}WSL USB Passthrough Notes:${NC}"
    echo "  - Requires usbipd-win on Windows host"
    echo "  - Must run PowerShell as Administrator"
    echo "  - Commands:"
    echo "      usbipd wsl list"
    echo "      usbipd wsl attach --busid X-Y"
    echo "  - USB devices can disconnect on Windows sleep/hibernate"
else
    echo -e "${GREEN}✓ Native Linux (not WSL)${NC}"
fi
echo ""

# 7. Provide recommendations
echo -e "${BLUE}[7/7] Recommendations...${NC}"
echo ""

ISSUES_FOUND=false

# No js* devices
if ! ls /dev/input/js* &> /dev/null; then
    ISSUES_FOUND=true
    echo -e "${YELLOW}📋 Issue: No /dev/input/js* devices${NC}"
    echo "   Cause: joydev kernel module not available"
    echo "   Solution: Use evdev interface instead"
    echo "   Action: Modify boxes-live to use /dev/input/event0"
    echo ""
fi

# Permissions
if ! groups | grep -q "input"; then
    ISSUES_FOUND=true
    echo -e "${YELLOW}📋 Issue: User not in input group${NC}"
    echo "   Cause: Need input group for device access"
    echo "   Solution: sudo usermod -a -G input $USER"
    echo "   Then: Log out and log back in"
    echo ""
fi

# USB device found but no input devices
if lsusb | grep -qi "joystick\|gamepad\|trooper\|xbox" && ! ls /dev/input/event* &> /dev/null; then
    ISSUES_FOUND=true
    echo -e "${RED}📋 Issue: USB device found but no input devices${NC}"
    echo "   Cause: Driver not loaded or device not recognized"
    echo "   Solution: Check dmesg for errors"
    echo "   Command: dmesg | grep -i joystick"
    echo ""
fi

if ! $ISSUES_FOUND; then
    echo -e "${GREEN}✓ No major issues detected${NC}"

    if ls /dev/input/event* &> /dev/null; then
        FIRST_EVENT=$(ls /dev/input/event* | head -1)
        echo ""
        echo "✅ Next steps:"
        echo "   1. Test joystick with: evtest $FIRST_EVENT"
        echo "   2. Or use our simple test: ./joystick-test"
        echo "   3. Verify buttons and axes work"
    fi
fi

echo ""
echo "=========================================="
echo "Diagnostic Complete"
echo "=========================================="
echo ""
echo "💡 Tip: For detailed joystick testing, run:"
echo "   ./joystick-test           # Our simple test tool"
echo "   evtest /dev/input/event0  # System event viewer (if installed)"
