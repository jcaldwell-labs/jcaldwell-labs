# USB Stuck Process Diagnostic Report

**Date**: 2025-11-22 11:46:00
**Process ID**: 1284
**Status**: D (Uninterruptible Sleep) - Cannot be killed

---

## Executive Summary

Python process (PID 1284) running `run_terminal_arcade.py` is stuck in kernel space waiting for a USB device operation to complete. The process is in "D" state (uninterruptible sleep), making it immune to all signals including SIGKILL (-9).

**Root Cause**: Process is blocked in kernel function `usb_wait_anchor_empty_timeout` - waiting for USB device communication with Hyperkin Trooper V2 gamepad controllers.

**Resolution**: Reboot required (cannot be resolved without kernel intervention).

---

## Detailed Analysis

### Process Information

```
PID:    1284
PPID:   1231 (/init - systemd/WSL init)
User:   be-dev-agent
State:  D (disk sleep / uninterruptible sleep)
Command: [python3] (zombie/stuck - brackets indicate defunct)
Started: 11:46:00
CPU Time: 00:00:44
```

### Kernel Stack Trace

**Waiting in kernel function**: `usb_wait_anchor_empty_timeout`

This function is part of the USB core driver and waits for USB URB (USB Request Blocks) to complete. When a USB device disconnects or becomes unresponsive during an operation, this function can hang indefinitely.

### USB Devices Detected

```
Bus 001 Device 003: ID 2e24:386a Hyperkin  Trooper V2
Bus 001 Device 004: ID 2e24:386a Hyperkin  Trooper V2
```

**Two Hyperkin Trooper V2 gamepads** connected via USB/IP Virtual Host Controller (WSL USB passthrough).

### Application Context

**Script**: `/home/be-dev-agent/projects/atari-style/run_terminal_arcade.py`
**Framework**: Terminal Arcade - Atari-style games with joystick support
**Input Library**: pygame (uses USB HID for joystick access)

### Code Analysis - Input Handler

**File**: `/home/be-dev-agent/projects/atari-style/terminal_arcade/engine/input_handler.py`

**Current behavior**:
1. pygame.init() and pygame.joystick.init() called at startup (line 41-42)
2. Joystick detected and initialized (line 44-46)
3. Periodic reconnection attempts every 30 frames (~1 second) if disconnected (line 65-112)
4. pygame.event.pump() called repeatedly to poll joystick state (lines 54, 105, 119, 135, 168)

**Problem**: No timeout or signal handling when pygame waits for USB device response.

---

## Why Kill -9 Failed

The process is in **"D" state** (uninterruptible sleep):
- State flag: `D` in `ps` output
- Process is executing kernel code and cannot be interrupted
- SIGKILL (signal 9) is queued but cannot be delivered until process returns to user space
- Process will never return to user space because USB device is not responding

**From /proc/1284/status**:
```
State:  D (disk sleep)
ShdPnd: 0000000000000100  (signal pending - likely our SIGKILL)
```

Signal is pending but cannot be delivered.

---

## Root Cause Analysis

### Sequence of Events

1. Terminal Arcade application started with pygame joystick support
2. Two Hyperkin Trooper V2 gamepads detected via WSL USB/IP passthrough
3. pygame initialized joysticks successfully
4. During operation, USB device became unresponsive (possibly WSL USB passthrough issue)
5. pygame.event.pump() called, which internally calls USB driver functions
6. USB driver function `usb_wait_anchor_empty_timeout` entered uninterruptible wait
7. USB device never responds, function never returns
8. Process permanently stuck in kernel space

### WSL USB Passthrough Considerations

**vhci_hcd**: Virtual Host Controller Interface for USB/IP
- WSL uses USB/IP to pass USB devices from Windows to Linux
- More prone to disconnection/timeout issues than native USB
- When Windows suspends/removes device, Linux kernel may not handle cleanup gracefully

**From dmesg**:
```
[  557.475126] usb 1-1: USB disconnect, device number 2
[ 4568.332085] usb 1-1: new low-speed USB device number 3 using vhci_hcd
```

USB device disconnected and reconnected during session - likely contributor to stuck state.

---

## Recommended Fixes for Post-Reboot

### 1. Add Signal Handlers (High Priority)

**File**: `run_terminal_arcade.py` or `terminal_arcade/main.py`

Add graceful shutdown on SIGTERM, SIGINT:

```python
import signal
import sys

def signal_handler(sig, frame):
    """Handle termination signals gracefully."""
    print("\nReceived shutdown signal, cleaning up...")
    # Cleanup pygame
    try:
        import pygame
        if pygame.get_init():
            pygame.joystick.quit()
            pygame.quit()
    except:
        pass
    sys.exit(0)

# Register handlers
signal.signal(signal.SIGINT, signal_handler)   # Ctrl+C
signal.signal(signal.SIGTERM, signal_handler)  # kill command
```

### 2. Add Timeouts to Joystick Operations (Critical)

**File**: `terminal_arcade/engine/input_handler.py`

Wrap pygame operations in timeout context:

```python
import signal
from contextlib import contextmanager

@contextmanager
def timeout(seconds):
    """Context manager for timeout on blocking operations."""
    def timeout_handler(signum, frame):
        raise TimeoutError("Operation timed out")

    old_handler = signal.signal(signal.SIGALRM, timeout_handler)
    signal.alarm(seconds)
    try:
        yield
    finally:
        signal.alarm(0)
        signal.signal(signal.SIGALRM, old_handler)

def get_joystick_state(self) -> Tuple[float, float]:
    """Get joystick axis state with timeout protection."""
    if not self.joystick_initialized:
        return (0.0, 0.0)

    try:
        with timeout(1):  # 1 second timeout
            pygame.event.pump()
            x = self.joystick.get_axis(0) if self.joystick.get_numaxes() > 0 else 0.0
            y = self.joystick.get_axis(1) if self.joystick.get_numaxes() > 1 else 0.0
            # ... rest of function
    except TimeoutError:
        # USB device not responding, mark as disconnected
        self.joystick_initialized = False
        if self.joystick:
            try:
                self.joystick.quit()
            except:
                pass
            self.joystick = None
        return (0.0, 0.0)
```

### 3. Add Joystick Health Checks

Add periodic validation that joystick is still responsive:

```python
def _check_joystick_health(self):
    """Verify joystick is still responding."""
    if not self.joystick_initialized:
        return False

    try:
        with timeout(1):
            # Simple read operation
            pygame.event.pump()
            _ = self.joystick.get_numaxes()
            return True
    except (TimeoutError, Exception):
        # Joystick not responding, disconnect it
        self.joystick_initialized = False
        return False
```

### 4. Use Non-Blocking USB Access (Advanced)

Consider using evdev or hidapi libraries instead of pygame for direct USB access with non-blocking I/O:

```python
# Alternative: Use evdev with non-blocking I/O
from evdev import InputDevice, categorize, ecodes
import select

device = InputDevice('/dev/input/event0')
device.grab()  # Exclusive access

# Non-blocking read with timeout
while True:
    r, w, x = select.select([device.fd], [], [], 0.1)  # 100ms timeout
    if r:
        for event in device.read():
            # Process event
            pass
```

### 5. Watchdog Timer (Defensive)

Add application-level watchdog that can detect and restart hung operations:

```python
import threading
import time

class WatchdogTimer:
    def __init__(self, timeout=5):
        self.timeout = timeout
        self.last_heartbeat = time.time()
        self.running = True
        self.thread = threading.Thread(target=self._watchdog, daemon=True)
        self.thread.start()

    def heartbeat(self):
        """Called regularly by main loop."""
        self.last_heartbeat = time.time()

    def _watchdog(self):
        """Monitor heartbeat and force exit if hung."""
        while self.running:
            time.sleep(1)
            if time.time() - self.last_heartbeat > self.timeout:
                print("WATCHDOG: Application hung, forcing exit")
                os._exit(1)  # Hard exit
```

---

## Immediate Actions

### Before Reboot
- [x] Document process state
- [x] Identify kernel wait function
- [x] Analyze application code
- [x] Create fix recommendations

### After Reboot
1. Review and apply signal handler fixes to run_terminal_arcade.py
2. Add timeout protection to input_handler.py pygame operations
3. Test with USB joysticks connected
4. Test disconnect/reconnect scenarios
5. Consider alternative USB libraries (evdev, hidapi) if pygame issues persist

---

## Technical Details for Reference

### Process State Flags
- **D** = Uninterruptible sleep (usually IO wait)
- **Z** = Zombie (terminated but not reaped)
- **R** = Running
- **S** = Interruptible sleep

### USB/IP in WSL
- Uses kernel module `vhci_hcd` (Virtual Host Controller Interface)
- USB devices passed from Windows host to WSL Linux guest
- More fragile than native USB due to network layer
- Prone to issues on Windows sleep/hibernate
- Can leave kernel in stuck state when device disappears unexpectedly

### pygame USB Access
- pygame uses SDL2 library for joystick support
- SDL2 uses hidapi or evdev (on Linux) for USB HID access
- Operations are synchronous and blocking
- No built-in timeout mechanism
- Depends on kernel USB drivers to respond

---

## Files Requiring Changes

1. `/home/be-dev-agent/projects/atari-style/run_terminal_arcade.py`
   - Add signal handlers

2. `/home/be-dev-agent/projects/atari-style/terminal_arcade/main.py`
   - Add cleanup on exit

3. `/home/be-dev-agent/projects/atari-style/terminal_arcade/engine/input_handler.py`
   - Add timeout context manager
   - Wrap pygame.event.pump() calls with timeouts
   - Add joystick health checks
   - Improve error handling in reconnection logic

---

## Prevention Strategy

### Short Term
- Add signal handlers and timeouts (1-2 hours work)
- Test thoroughly with USB devices

### Medium Term
- Consider switching to evdev for direct USB access (more control)
- Add application watchdog timer
- Improve USB disconnect detection and recovery

### Long Term
- Investigate pygame alternatives for joystick support
- Consider contributing timeout patches to pygame/SDL2
- Document WSL USB passthrough limitations for users

---

## Conclusion

Process is unrecoverably stuck in kernel USB code. **Reboot required** to clear.

After reboot, implement signal handlers and timeout protection to prevent recurrence.

The issue is not a bug in the application logic, but a lack of defensive programming against blocking USB operations in an environment (WSL USB/IP) known for connectivity issues.

**Estimated fix effort**: 2-3 hours
**Priority**: High (prevents system lockup)
**Risk**: Low (changes are defensive only)

---

**Report Generated**: 2025-11-22 12:00:00
**Next Action**: Reboot system, then apply recommended fixes
