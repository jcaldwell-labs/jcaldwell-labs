# Joystick Setup Guide for WSL2

**Issue**: WSL2 USB passthrough for joysticks requires special setup
**Solution**: Complete workflow documented here

---

## Problem Summary

**Symptoms**:
- USB joystick visible in Windows
- `lsusb` shows device in WSL
- No `/dev/input/js*` devices in WSL
- boxes-live joystick features don't work

**Root Causes**:
1. WSL kernel doesn't include `joydev` module (creates /dev/input/js*)
2. Must use `evdev` interface (/dev/input/event*) instead
3. USB/IP passthrough can be unstable
4. Requires admin PowerShell on Windows

---

## Current Status

Run diagnostic to check your setup:

```bash
cd ~/projects/jcaldwell-labs
./scripts/joystick-diagnostic.sh
```

---

## Solution: Use evdev Interface

Since WSL kernel lacks `joydev` module, we use `evdev` interface (`/dev/input/event*`) instead of traditional joystick interface (`/dev/input/js*`).

### Step 1: Verify USB Connection

**In WSL**:
```bash
lsusb
# Should show: Bus 001 Device 002: ID 2e24:386a Hyperkin  Trooper V2
```

**If not shown**:
```powershell
# In Windows PowerShell (Run as Administrator)
usbipd wsl list
# Find your joystick bus-id (e.g., 1-4)

usbipd wsl attach --busid 1-4
# Replace 1-4 with actual bus-id
```

### Step 2: Check Event Device

**In WSL**:
```bash
ls -la /dev/input/event*
# Should show: crw-rw---- 1 root input 13, 64 ... /dev/input/event0

cat /proc/bus/input/devices | grep -A 10 "Trooper\|Joystick"
# Should show: H: Handlers=event0
```

### Step 3: Test Connectivity

**Using our test tool**:
```bash
cd ~/projects/jcaldwell-labs/tools
./joystick-test /dev/input/event0
# Move sticks and press buttons - should see output
```

**Using system tool** (if available):
```bash
sudo apt-get install evtest
evtest /dev/input/event0
```

---

## Fixing boxes-live

boxes-live currently uses `/dev/input/js*` (joydev) API. We need to update it to use `/dev/input/event*` (evdev) API.

### Required Changes

**File**: `src/joystick.c`

**Current**:
```c
state->fd = open("/dev/input/js0", O_RDONLY | O_NONBLOCK);
```

**New**:
```c
state->fd = open("/dev/input/event0", O_RDONLY | O_NONBLOCK);
// Use evdev event structure instead of js_event
```

**Additional Changes**:
- Update event parsing (evdev uses different event structure)
- Map EV_ABS events to axes
- Map EV_KEY (BTN_GAMEPAD/BTN_JOYSTICK) to buttons
- Update joystick.h to use `<linux/input.h>` instead of `<linux/joystick.h>`

---

## WSL USB Passthrough Workflow

### Initial Setup (Once)

**1. Install usbipd-win on Windows**:
```powershell
# In Windows PowerShell (Run as Administrator)
winget install usbipd
```

**2. Find Joystick Bus ID**:
```powershell
# In PowerShell (Run as Administrator)
usbipd wsl list
```

Output example:
```
BUSID  VID:PID    DEVICE
1-4    2e24:386a  Hyperkin Trooper V2
```

Note the BUSID (e.g., `1-4`)

### Every Time (After Reboot or Disconnect)

**Attach Joystick to WSL**:
```powershell
# In PowerShell (Run as Administrator)
usbipd wsl attach --busid 1-4
```

**Verify in WSL**:
```bash
lsusb | grep Hyperkin
# Should appear

ls -la /dev/input/event0
# Should exist
```

### Automating (Future)

Create PowerShell script:
```powershell
# attach-joystick.ps1
usbipd wsl attach --busid 1-4
Write-Host "Joystick attached to WSL"
```

Run as admin when needed.

---

## Permissions

If you get "Permission denied" accessing `/dev/input/event0`:

```bash
# Add user to input group
sudo usermod -a -G input $USER

# Log out and log back in
# Or start new shell with group:
newgrp input

# Verify
groups | grep input
# Should show 'input'
```

---

## Known Issues & Workarounds

### Issue: Joystick Disconnects Randomly

**Cause**: Windows power management, USB/IP instability
**Symptoms**: Device disappears from `lsusb`, /dev/input/event0 gone
**Workaround**:
```powershell
# Re-attach in PowerShell
usbipd wsl attach --busid 1-4
```

### Issue: "Run as Administrator" Required

**Cause**: usbipd requires admin privileges
**Workaround**: Create shortcut with "Run as administrator" enabled

### Issue: Device Shows but Can't Read

**Cause**: Permission issue or wrong device
**Checks**:
```bash
# Verify readable
if [ -r /dev/input/event0 ]; then echo "Readable"; else echo "Not readable"; fi

# Check what it is
cat /proc/bus/input/devices | grep -A 10 "event0"
```

---

## Alternative: Native Linux

If WSL USB passthrough is too problematic:

**Option 1**: Boot native Linux
- Joystick works natively
- No USB/IP complexity
- Direct kernel support

**Option 2**: Use Linux VM
- VirtualBox/VMware with USB passthrough
- More reliable than WSL USB/IP

**Option 3**: Develop on Windows
- Port boxes-live to Windows (cygwin/mingw)
- Or use Windows-native joystick API

---

## Testing Workflow

### 1. Verify Hardware
```bash
# USB device present?
lsusb | grep -i "joystick\|gamepad\|trooper"
```

### 2. Verify Kernel Interface
```bash
# Event device present?
ls -la /dev/input/event0

# Device readable?
[ -r /dev/input/event0 ] && echo "OK" || echo "Permission issue"
```

### 3. Test Input
```bash
# Run test tool
cd ~/projects/jcaldwell-labs/tools
./joystick-test /dev/input/event0
# Move sticks and press buttons
```

### 4. Update boxes-live
```bash
# Modify to use evdev interface
# Test with actual joystick
```

---

## Next Steps

1. ✅ Diagnostic tool created (`joystick-diagnostic.sh`)
2. ✅ Test utility created (`joystick-test`)
3. ⏭️ Update boxes-live to use evdev interface
4. ⏭️ Test boxes-live with actual joystick
5. ⏭️ Merge and continue Phase 2

---

**Created**: 2025-11-22
**Status**: Documentation complete, boxes-live update pending
