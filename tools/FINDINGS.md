# Joystick Testing Findings

## Session: 2025-11-22

### Problem
- Previous joystick test was crashing or not detecting diagonal movement
- Only seeing X or Y axis changes, not both simultaneously

### Root Cause Analysis

#### 1. Axis Range Mismatch
**Expected:** -32768 to 32767 (signed 16-bit)
**Actual:** 0 to 255 (unsigned 8-bit)

The "Trooper V2" joystick uses a different range than typical game controllers:
- Center position: 127 (not 0)
- Full left/up: 0
- Full right/down: 255
- Deadzone: ±15 units around center

#### 2. Event Pattern (Diagonal Movement)
Diagonal movement is **NOT** reported as simultaneous X+Y changes. Instead:

```
TIME         TYPE    CODE    VALUE
1763839453.6 EV_ABS  ABS_X   45      <- X changes
1763839453.6 EV_SYN  SYNC    ---
1763839453.8 EV_ABS  ABS_Y   67      <- Y changes separately
1763839453.8 EV_SYN  SYNC    ---
```

**This is normal behavior!** The joystick reports axis changes independently. Application code must:
1. Maintain state for each axis
2. Update visualization on ANY axis change
3. Not expect both axes in same event

#### 3. Device Information

```
Device: Trooper V2      Trooper V2
Vendor: 0x2e24
Product: 0x386a
Bus: USB (0x0003)

Axes:
- ABS_X:  0-255 (left stick horizontal)
- ABS_Y:  0-255 (left stick vertical)
- ABS_40: 0-255 (unknown - possibly triggers or right stick)

Buttons:
- BTN_JOYSTICK_0 through BTN_JOYSTICK_7
```

### Solutions Implemented

#### 1. joystick-visualizer
- **Split-screen display:** ASCII visualization + raw event log
- **Real-time updates:** Shows stick position on ANY axis change
- **Event history:** Last 10 events with timestamps
- **Comprehensive info:** Direction, angle, magnitude, button states

#### 2. joystick-raw
- **Device capabilities:** Shows min/max ranges for all axes
- **Raw event dump:** Every event with full details
- **Debugging:** Identifies exact event patterns and timing

#### 3. Updated joystick-test
- Fixed to handle 0-255 range
- Maintains separate state for X and Y
- Updates on any axis change

### Key Learnings

1. **Always check device capabilities first**
   - Use `joystick-raw` to see actual axis ranges
   - Don't assume standard ranges

2. **Diagonal movement = 2 events**
   - Not a bug, this is how evdev works
   - Maintain state, don't wait for simultaneous changes

3. **WSL2 specifics**
   - Uses evdev, not joydev (/dev/input/eventX, not /dev/input/jsX)
   - Requires USB passthrough from Windows (usbipd)
   - Works well once connected

4. **Deadzones are essential**
   - Center isn't exactly 127
   - Recommend 0.15 normalized deadzone (±19 units)
   - Prevents drift and jitter

### Testing Results

All tools working correctly:

```bash
# Visual + events (best for general testing)
./joystick-visualizer /dev/input/event0
✓ Shows stick position correctly
✓ Detects all 8 directions + center
✓ Displays raw events in real-time
✓ Button states accurate

# Raw dump (best for debugging)
./joystick-raw /dev/input/event0
✓ Device info correct
✓ All events captured
✓ Timestamps accurate

# Simple test
./joystick-test /dev/input/event0
✓ Basic visualization works
✓ Directions detected
```

### Next Steps for boxes-live Integration

1. **Use 0-255 range** (or normalize based on device capabilities)
2. **Implement state-based input** (don't wait for simultaneous events)
3. **Apply deadzone** (0.15 recommended)
4. **Test with joystick-raw first** to understand device characteristics

### Example Code Pattern

```c
// Query device capabilities
struct input_absinfo info;
ioctl(fd, EVIOCGABS(ABS_X), &info);
int center = (info.minimum + info.maximum) / 2;
int range = info.maximum - center;

// Normalize axis value
double normalize_axis(int raw_value) {
    double normalized = (raw_value - center) / (double)range;
    if (fabs(normalized) < 0.15) normalized = 0.0;  // deadzone
    return normalized;
}

// Maintain state
int axis_x = center, axis_y = center;

// Update on events
if (ev.type == EV_ABS) {
    if (ev.code == ABS_X) axis_x = ev.value;
    if (ev.code == ABS_Y) axis_y = ev.value;
    redraw();  // Update on ANY axis change
}
```

### Files Created

- `joystick-visualizer.c` - Interactive visualizer with event log
- `joystick-raw.c` - Raw event dumper with device info
- `test-joystick.sh` - Menu-driven test launcher
- `README.md` - Complete documentation
- `FINDINGS.md` - This document
- `Makefile` - Updated to build all tools

### Performance Notes

- Event rate: ~60-100 Hz during active movement
- No dropped events observed
- Low CPU usage (<5% per tool)
- Terminal rendering stable at 20 Hz update rate
