# Complete Development Workflow Guide

> Step-by-step guide for developing features across jcaldwell-labs projects using the full toolchain.

**Created**: 2025-11-25
**Audience**: Developers working on jcaldwell-labs projects
**Prerequisites**: Git, Go 1.21+, GCC, ncurses-dev installed

---

## Overview

This guide demonstrates a complete development workflow using:

- **my-context** - Session tracking and decision journaling
- **Unified build system** - Cross-project building and testing
- **termui library** - Shared terminal UI components
- **Git workflow** - Branch, PR, and merge patterns

---

## Quick Reference

```bash
# Start any development session
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "feature-name-$(date +%Y-%m-%d)"

# Build everything
make build-all

# Test everything
make test-all

# Track decisions
my-context note "Decision: chose X because Y"

# End session
my-context stop
my-context export "feature-name-$(date +%Y-%m-%d)"
```

---

## Part 1: Starting a Development Session

### Step 1.1: Set Up Context Tracking

Always start with context tracking to maintain a decision journal:

```bash
# Navigate to your working directory
cd ~/projects/jcaldwell-labs

# Set up my-context for the organization
export MY_CONTEXT_HOME=db:jcaldwell_labs

# Start a tracked session with descriptive name
my-context start "feature-add-color-themes-2025-11-25"

# Verify session is active
my-context show
```

**Expected output:**
```
Context: feature-add-color-themes-2025-11-25
Status: active
Started: 2025-11-25 10:30:00
Duration: 0m
Notes: 0
Files: 0
```

### Step 1.2: Verify Environment

Check that the build system is working:

```bash
# From jcaldwell-labs root
make help
```

**Expected output:**
```
jcaldwell-labs Organization Build System
========================================

Available targets:
  make build-all     - Build all projects (C and Go)
  make test-all      - Run all tests
  make build-c-all   - Build all C projects
  make test-c-all    - Run all C project tests
  make build-go-all  - Build all Go projects
  make test-go-all   - Run all Go project tests
  make clean-all     - Clean all projects
  make help          - Show this help
```

### Step 1.3: Document Your Goal

Record what you're trying to accomplish:

```bash
my-context note "Goal: Add color theme support to terminal-stars"
my-context note "Approach: Use termui color constants, add theme selection menu"
```

---

## Part 2: Making Changes

### Step 2.1: Create Feature Branch

```bash
# Navigate to the project you're modifying
cd ~/projects/terminal-stars

# Ensure you're on latest main
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/color-themes

# Record the branch
my-context note "Created branch: feature/color-themes in terminal-stars"
```

### Step 2.2: Understand Existing Code

Before making changes, read relevant code:

```bash
# Check the terminal UI wrapper
cat src/terminal.c

# Note what you learned
my-context note "terminal.c uses termui library for init/cleanup/resize"
my-context file src/terminal.c
```

### Step 2.3: Make Your Changes

Edit the code as needed. After each significant change:

```bash
# Record what you changed
my-context note "Added theme enum with 4 options: DEFAULT, NIGHT, DAY, COLORBLIND"
my-context file src/themes.c
my-context file include/themes.h
```

### Step 2.4: Build Incrementally

Test your build frequently:

```bash
# Build just your project
make clean
make

# If successful, note it
my-context note "Build successful with new theme files"
```

---

## Part 3: Testing

### Step 3.1: Run Project Tests

```bash
# Run the project's test suite
make test
```

**Expected output:**
```
Running all tests...
==========================================
Running tests/bin/test_physics...
==========================================
All physics tests passed!

==========================================
Running tests/bin/test_renderer...
==========================================
All renderer tests passed!

==========================================
All tests passed!
==========================================
```

### Step 3.2: Run Cross-Project Tests

If your changes affect shared components:

```bash
# Go back to organization root
cd ~/projects/jcaldwell-labs

# Run all C project tests
make test-c-all
```

### Step 3.3: Manual Testing

For UI changes, run the application:

```bash
cd ~/projects/terminal-stars
./terminal-stars

# Test each theme
# Press 't' to cycle themes (hypothetical feature)
# Press 'q' to quit

# Record results
my-context note "Manual test: All 4 themes render correctly, no flickering"
```

---

## Part 4: Creating a Pull Request

### Step 4.1: Pre-PR Validation

Run the pre-PR check script:

```bash
cd ~/projects/jcaldwell-labs
./scripts/pre-pr-check.sh ~/projects/terminal-stars
```

**Expected output:**
```
Pre-PR Validation for terminal-stars
====================================
[OK] Build succeeds
[OK] No compiler warnings
[OK] All tests pass
[OK] No uncommitted changes
====================================
Ready to create PR!
```

### Step 4.2: Commit Changes

```bash
cd ~/projects/terminal-stars

# Stage your changes
git add src/themes.c include/themes.h src/main.c

# Create a meaningful commit
git commit -m "feat: Add color theme support

- Add 4 built-in themes: DEFAULT, NIGHT, DAY, COLORBLIND
- Add 't' key binding to cycle through themes
- Persist theme selection across sessions
- Use termui color constants for consistency

🤖 Generated with Claude Code"

# Push to remote
git push -u origin feature/color-themes
```

### Step 4.3: Create PR

```bash
gh pr create --title "feat: Add color theme support" --body "## Summary
- Adds 4 color themes for accessibility and preference
- Theme persists in config file

## Test Plan
- [x] Build succeeds with zero warnings
- [x] All existing tests pass
- [x] Manual test of each theme
- [x] Verified theme persistence

🤖 Generated with Claude Code"
```

### Step 4.4: Monitor CI

```bash
# Watch CI status
gh pr checks

# Wait for all checks to pass
# If any fail, fix and push again
```

---

## Part 5: Completing the Session

### Step 5.1: Record Completion

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context note "PR created: terminal-stars #XX - color theme support"
my-context note "Status: Waiting for CI and review"
```

### Step 5.2: Export Session

```bash
# Export your session for documentation
my-context export "feature-add-color-themes-2025-11-25"
```

This creates a markdown file with all your notes, decisions, and file associations.

### Step 5.3: Stop Session (Optional)

If you're done for the day:

```bash
my-context stop
```

---

## Part 6: Common Scenarios

### Scenario A: Working on Multiple Projects

```bash
# Start session
my-context start "cross-project-refactor-2025-11-25"

# Work on termui library
cd ~/projects/jcaldwell-labs/libs/termui
# make changes...
my-context note "Updated termui: added new color constant"
my-context file libs/termui/include/termui.h

# Update dependent project
cd ~/projects/terminal-stars
# update to use new constant...
my-context note "Updated terminal-stars to use new TERMUI_COLOR_ORANGE"
my-context file src/renderer.c

# Build everything to ensure compatibility
cd ~/projects/jcaldwell-labs
make build-c-all
make test-c-all

my-context note "Cross-project build successful"
```

### Scenario B: Debugging a Test Failure

```bash
# Run tests with verbose output
make test 2>&1 | tee test-output.log

# Record the failure
my-context note "Test failure in test_renderer: expected 60fps, got 45fps"
my-context file test-output.log

# After fixing
my-context note "Fixed: frame timing was not accounting for vsync delay"
```

### Scenario C: Reviewing Someone Else's PR

```bash
# Start review session
my-context start "pr-review-terminal-stars-42-2025-11-25"

# Checkout the PR
gh pr checkout 42

# Build and test
make clean && make
make test

# Record findings
my-context note "PR 42 review: Build OK, tests pass"
my-context note "Suggestion: Add error handling for null config"

# Leave review
gh pr review 42 --approve --body "LGTM with minor suggestion"

my-context note "Approved PR 42"
my-context stop
```

---

## Part 7: Troubleshooting

### Build Fails

```bash
# Check for missing dependencies
make build-all 2>&1 | grep -i "error\|not found"

# Common fixes:
sudo apt-get install libncurses-dev  # for C projects
go mod tidy                           # for Go projects
```

### Tests Fail in CI but Pass Locally

```bash
# Run with same conditions as CI
make clean
CC=gcc make        # CI uses gcc
make test

# Check for environment-specific issues
my-context note "Investigating CI failure..."
```

### my-context Not Found

```bash
# Check if installed
which my-context

# If not installed, build it
cd ~/projects/my-context
make build
sudo make install
```

---

## Summary Checklist

Before starting:
- [ ] `export MY_CONTEXT_HOME=db:jcaldwell_labs`
- [ ] `my-context start "descriptive-name-date"`

During development:
- [ ] Create feature branch
- [ ] `my-context note` for decisions
- [ ] `my-context file` for changed files
- [ ] Build and test frequently

Before PR:
- [ ] `./scripts/pre-pr-check.sh`
- [ ] All tests pass
- [ ] Meaningful commit message

After PR:
- [ ] Monitor CI
- [ ] `my-context export`
- [ ] `my-context stop`

---

## Related Documentation

- [my-context Integration Pattern](../MY-CONTEXT-INTEGRATION.md) (fintrack example)
- [Terminal UI Patterns](../TERMINAL-UI-PATTERNS.md)
- [PR Failure Protocol](../PR-FAILURE-PROTOCOL.md)
- [Done Definition](../DONE-DEFINITION.md)

---

**Document Version**: 1.0
**Last Updated**: 2025-11-25
