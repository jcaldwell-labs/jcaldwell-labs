# Joystick Testing Tools

Comprehensive suite for testing USB joysticks/gamepads in Linux (especially WSL2).

## Overview

This toolset was created to debug and visualize joystick input on WSL2 with USB passthrough. It provides multiple views into joystick events:

1. **joystick-visualizer** - Interactive ASCII visualization + event log
2. **joystick-raw** - Detailed raw event dump with device capabilities
3. **joystick-test** - Simple visual stick position test
4. **debug-joystick** - Quick device connectivity check

## Quick Start

### 1. Connect Joystick (WSL2/Windows)

From PowerShell on Windows:
```powershell
cd C:\Users\YourName
.\attach_joystick.ps1
```

This will:
- List USB devices
- Bind your joystick (look for Xbox/PlayStation/Logitech/etc)
- Attach it to WSL2

### 2. Build Tools

```bash
cd ~/projects/jcaldwell-labs/tools
make
```

### 3. Run Tests

**Option A: Interactive Menu**
```bash
./test-joystick.sh
```

**Option B: Run Directly**
```bash
# Visual + event log (recommended)
./joystick-visualizer /dev/input/event0

# Raw event dump (debugging)
./joystick-raw /dev/input/event0

# Simple visual test
./joystick-test /dev/input/event0
```

## Tool Details

### joystick-visualizer

**Best for:** General testing and understanding input

Shows:
- ASCII art visualization of stick position with direction line
- Real-time direction (UP, DOWN-LEFT, etc)
- Angle and magnitude calculations
- Button states (triggers, face buttons, etc)
- Last 10 raw events with timestamps

**Example Output:**
```
═══════════════════════════════════════════════════════════════════════
                    JOYSTICK VISUALIZER v2.0
═══════════════════════════════════════════════════════════════════════
Device:  Trooper V2      Trooper V2
Axes: ABS_X, ABS_Y, ABS_40

  LEFT STICK:
            |
            |
       *    |
      *     |
     *      |
    @       |
  ----------+----------
            |
            |
            |

  RAW: X=     45 Y=     67 | NORM: X=-0.64 Y=-0.47
  DIR: UP-LEFT    | ANGLE: -143.5° MAG: 0.79

  BUTTONS:
    Triggers: L[○] R[○] | Face: A[●] B[○] X[○] Y[○] | SEL[○] START[○]

  ═══════════════════════════════════════════════════════════════════════
  RAW EVENT STREAM (last 10 events):
  ───────────────────────────────────────────────────────────────────────
  TIME(s)      TYPE   CODE         VALUE
  ───────────────────────────────────────────────────────────────────────
  1763839453.6 EV_ABS ABS_X        45
  1763839453.6 EV_SYN SYNC         ---
  1763839453.8 EV_KEY BTN_JS_0     PRESS
  1763839453.8 EV_SYN SYNC         ---
  ...
```

### joystick-raw

**Best for:** Deep debugging, device capabilities, event inspection

Shows:
- Full device information (vendor ID, product ID, bus type)
- All supported axes with min/max ranges
- All supported buttons
- Complete raw event stream with precise timestamps
- Event types, codes, and values

**Example Output:**
```
════════════════════════════════════════════════════════════════
DEVICE: /dev/input/event0
NAME:    Trooper V2      Trooper V2
BUS:    0x0003  VENDOR: 0x2e24  PRODUCT: 0x386a  VERSION: 0x0110
════════════════════════════════════════════════════════════════

SUPPORTED AXES:
  ABS_X            min=     0 max=   255 fuzz=0 flat=15
  ABS_Y            min=     0 max=   255 fuzz=0 flat=15
  ABS_40           min=     0 max=   255 fuzz=0 flat=15

SUPPORTED BUTTONS:
  BTN_JOYSTICK_0 BTN_JOYSTICK_1 BTN_JOYSTICK_2 BTN_JOYSTICK_3
  BTN_JOYSTICK_4 BTN_JOYSTICK_5 BTN_JOYSTICK_6 BTN_JOYSTICK_7

════════════════════════════════════════════════════════════════
RAW EVENT STREAM (Press Ctrl+C to stop):
────────────────────────────────────────────────────────────────
TIMESTAMP      TYPE               CODE               VALUE
────────────────────────────────────────────────────────────────
1763839453.6   EV_ABS             ABS_X              127
1763839453.6   EV_SYN             SYN_REPORT         ---
1763839454.0   EV_KEY             BTN_JOYSTICK_1     PRESS (1)
1763839454.2   EV_KEY             BTN_JOYSTICK_1     RELEASE (0)
```

### joystick-test

**Best for:** Quick visual check, simple testing

- Simple ASCII grid showing stick position
- Direction indicator (8-way + center)
- Button states
- Non-flashing display

### debug-joystick

**Best for:** Quick connectivity check

- Minimal output
- Shows if device is accessible
- Basic axis ranges

## Troubleshooting

### No /dev/input/event0

```bash
# List all input devices
ls -l /dev/input/event*

# Check which one is your joystick
cat /proc/bus/input/devices
```

Then use the correct device:
```bash
./joystick-visualizer /dev/input/event1  # or event2, etc
```

### Permission Denied

```bash
# Check permissions
ls -l /dev/input/event0

# Temporary fix (current session only)
sudo chmod a+r /dev/input/event0

# Permanent fix: add user to input group
sudo usermod -a -G input $USER
# Then log out and back in
```

### Joystick Not Detected in WSL

1. **Check Windows side:**
   ```powershell
   usbipd list
   ```
   Should show your joystick

2. **Re-attach:**
   ```powershell
   usbipd detach --busid 2-4
   usbipd attach --wsl --busid 2-4
   ```

3. **Check WSL side:**
   ```bash
   lsusb  # Should show your joystick
   dmesg | tail -20  # Check for USB connection messages
   ```

### Diagonal Detection Issues

Some joysticks report only X or Y axis changes, not both simultaneously:
- The **joystick-raw** tool will show you the exact event pattern
- If you see `ABS_X` and `ABS_Y` arrive separately, this is normal
- The visualizer handles this by maintaining state

### Different Axis Ranges

This toolset was tested with a "Trooper V2" joystick that uses:
- Range: 0-255 (center at 127)

Other joysticks may use:
- Range: -32768 to 32767 (center at 0) - most common
- Range: 0-1023 (center at 512) - some older devices

The **joystick-raw** tool will show you the exact min/max ranges for your device.

## Technical Details

### Event Types

- **EV_SYN** - Synchronization marker (end of event batch)
- **EV_ABS** - Absolute axis (stick position)
- **EV_KEY** - Button press/release
- **EV_MSC** - Miscellaneous (scan codes, etc)

### Axis Codes

- **ABS_X, ABS_Y** - Left stick
- **ABS_RX, ABS_RY** - Right stick (if present)
- **ABS_Z, ABS_RZ** - Triggers (some controllers)
- **ABS_HAT0X, ABS_HAT0Y** - D-pad

### Button Codes

- **BTN_SOUTH/BTN_GAMEPAD_0** - A button (Xbox) / Cross (PlayStation)
- **BTN_EAST/BTN_GAMEPAD_1** - B button (Xbox) / Circle (PlayStation)
- **BTN_NORTH/BTN_GAMEPAD_2** - Y button (Xbox) / Triangle (PlayStation)
- **BTN_WEST/BTN_GAMEPAD_3** - X button (Xbox) / Square (PlayStation)
- **BTN_TL/BTN_GAMEPAD_4** - Left trigger/bumper
- **BTN_TR/BTN_GAMEPAD_5** - Right trigger/bumper

## Development Notes

### Why Multiple Tools?

Each tool serves a different purpose:

1. **joystick-visualizer** - Day-to-day testing, understanding input
2. **joystick-raw** - Initial device setup, debugging event issues
3. **joystick-test** - Quick sanity check
4. **debug-joystick** - Automated testing, CI/CD

### Building for boxes-live Integration

These tools were created as part of developing joystick support for the `boxes-live` project. Lessons learned:

1. **WSL2 uses evdev, not joydev** - No /dev/input/js0
2. **Axis ranges vary** - Always check with joystick-raw first
3. **Events are atomic** - Diagonal movement = 2 events (X, then Y)
4. **Deadzones matter** - Center isn't always exact (0.15 deadzone recommended)

## License

Part of jcaldwell-labs toolkit. Use freely for testing and development.

## See Also

- Linux input subsystem: `Documentation/input/input.txt`
- evdev programming: `man evdev`
- WSL USB passthrough: https://docs.microsoft.com/en-us/windows/wsl/connect-usb
