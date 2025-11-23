# Phase 2 Parallel Session Prompts

**Generated**: 2025-11-22
**Purpose**: Ready-to-use prompts for launching 7 parallel Claude Code sessions for Phase 2 repository improvements

---

## Overview

This directory contains 7 comprehensive prompt files, one for each parallel session in Phase 2 of the jcaldwell-labs organization improvement project. Each prompt is designed to be fed directly to a Claude Code session running in the respective repository.

## How to Use These Prompts

### Preparation (Do This First)

1. **Ensure Phase 1 is complete**:
   - All PRs merged
   - All repos cloned and synced
   - System rebooted (PID 1284 cleared)
   - Health check passed

2. **Commit coordination framework** to jcaldwell-labs repo:
   ```bash
   cd ~/projects/jcaldwell-labs
   git add .
   git commit -m "Add Phase 2 parallel session prompts"
   git push
   ```

3. **Create PARALLEL-SESSION-MANIFEST.md**:
   - Follow instructions in PARALLEL-SESSION-GUIDE.md
   - Commit and push the manifest file

### Launching Sessions

For each repository, you'll:

1. **Navigate to the repository** (or launch Claude Code in that repo)
2. **Copy the entire contents** of the corresponding SESSION-X-PROMPT.txt file
3. **Paste it as your first message** to Claude Code
4. **Let the session run autonomously**

### Session Assignments

| Session | File | Repository | Complexity | Duration |
|---------|------|-----------|------------|----------|
| A | `SESSION-A-FINTRACK-PROMPT.txt` | fintrack | High | 6-8 hours |
| B | `SESSION-B-BOXES-LIVE-PROMPT.txt` | boxes-live | High | 6-8 hours |
| C | `SESSION-C-TERMINAL-STARS-PROMPT.txt` | terminal-stars | Medium | 4-6 hours |
| D | `SESSION-D-MY-CONTEXT-PROMPT.txt` | my-context | High | 6-8 hours |
| E | `SESSION-E-TARIO-PROMPT.txt` | tario | Medium | 4-6 hours |
| F | `SESSION-F-ADVENTURE-ENGINE-V2-PROMPT.txt` | adventure-engine-v2 | Medium | 4-6 hours |
| G | `SESSION-G-COMBINED-REPOS-PROMPT.txt` | smartterm-prototype, atari-style, .github | Low-Medium | 6-10 hours |

### Example Launch Sequence

#### Option 1: Via GitHub Web UI

1. Navigate to https://github.com/jcaldwell-labs/fintrack
2. Click "Code" → "Open with Claude"
3. Wait for Claude Code session to initialize
4. Copy entire contents of `SESSION-A-FINTRACK-PROMPT.txt`
5. Paste as your first message
6. Claude will confirm understanding and begin work

#### Option 2: Via Local Claude Code

```bash
# For Session A (fintrack)
cd ~/projects/jcaldwell-labs-repos
git clone https://github.com/jcaldwell-labs/fintrack.git
cd fintrack

# Launch Claude Code here
# Then paste contents of SESSION-A-FINTRACK-PROMPT.txt
```

### Monitoring Progress

Check `PARALLEL-SESSION-MANIFEST.md` in the jcaldwell-labs coordination repo to see status:

```bash
cd ~/jcaldwell-labs-coordination
git pull
cat PARALLEL-SESSION-MANIFEST.md
```

Sessions will update the manifest at:
- Start (claim repository)
- Completion (mark done)
- If blocked (note blocker)

---

## What Each Session Does

### Session A: fintrack (Go financial CLI)

**Checklist**:
- Standard improvements (docs, tests, CI, code quality)
- Complete transaction management features
- Add database migration strategy
- Improve CLI documentation
- Consider config file support

**Deliverables**:
- PR with improvements
- Improvement report
- Test coverage metrics
- Updated documentation

---

### Session B: boxes-live (C terminal canvas - Miro alternative)

**Checklist**:
- Standard improvements (docs, tests, CI, code quality)
- Complete canvas rendering engine
- Add protocol documentation
- Add example use cases
- Performance profiling and optimization

**Special Notes**:
- Flagship project - documentation quality critical
- Network protocol security review important
- Memory leak checks required

**Deliverables**:
- PR with improvements
- Improvement report
- Performance benchmarks
- Protocol specification

---

### Session C: terminal-stars (C starfield visualization)

**Checklist**:
- Standard improvements (docs, tests, CI, code quality)
- Complete space combat mode
- Fix encoding issues
- Add more visual modes
- Performance testing

**Deliverables**:
- PR with improvements
- Improvement report
- Performance metrics
- Mode documentation

---

### Session D: my-context (Go context management - PRODUCTION TOOL)

**Checklist**:
- Standard improvements (docs, tests, CI, code quality)
- Complete Sprint 3 features
- Add backup/restore functionality
- Improve PostgreSQL connection handling
- Add export format options (JSON, CSV)

**Special Notes**:
- **CRITICAL**: Production tool - backward compatibility required
- Test both database and file modes
- PostgreSQL connection robustness important

**Deliverables**:
- PR with improvements
- Improvement report
- Backward compatibility test results
- Export format examples

---

### Session E: tario (C ASCII platformer game)

**Checklist**:
- Standard improvements (docs, tests, CI, code quality)
- Complete platformer physics
- Add first playable level
- Add sound effects framework
- Create level editor or level format docs

**Deliverables**:
- PR with improvements
- Improvement report
- Playable level
- Level format documentation

---

### Session F: adventure-engine-v2 (C text adventure engine)

**Checklist**:
- Standard improvements (docs, tests, CI, code quality)
- Complete smart terminal UI
- Add save/load game functionality
- Add example adventure game
- Document scripting format

**Deliverables**:
- PR with improvements
- Improvement report
- Complete example game
- Scripting guide

---

### Session G: Combined Repos (smartterm-prototype, atari-style, .github)

**Works on THREE repositories sequentially**:

#### Part 1: smartterm-prototype (C terminal UI library)
- Standard improvements
- Extract reusable library
- Document API
- Add examples
- Consider graduating from "prototype"

#### Part 2: atari-style (Python arcade games) - **CRITICAL**
- Standard improvements
- **FIX USB STUCK PROCESS ISSUE** (mandatory)
- Add signal handlers
- Add timeout protection
- Add joystick health checks
- Document WSL USB limitations

#### Part 3: .github (Organization docs)
- Review organization profile README
- Add code of conduct
- Add security policy
- Update contributing guidelines
- Add discussion templates

**Special Notes**:
- **CRITICAL**: atari-style USB fix prevents system lockup
- Must read USB-STUCK-PROCESS-DIAGNOSTIC.md before starting
- .github changes affect entire organization

**Deliverables**:
- 3 separate PRs (one per repo)
- 3 separate improvement reports
- Combined context export

---

## Key Features of These Prompts

### Self-Contained
Each prompt includes:
- Complete context about the overall project
- Specific repository assignment
- Full standard checklist
- Repository-specific tasks
- Deliverable requirements
- Quality gates
- Time management guidance

### Autonomous Operation
Prompts are designed for sessions to run independently:
- No need for coordinator intervention
- Clear success criteria
- Blocker handling instructions
- Manifest update procedures

### Coordination Built-In
Sessions coordinate via:
- PARALLEL-SESSION-MANIFEST.md updates
- GitHub PRs
- Improvement reports in shared coordination repo
- my-context exports

### Safety and Quality
Each prompt includes:
- Time-boxing instructions
- Quality gates
- Memory leak checks (C projects)
- Security review reminders
- Testing requirements

---

## After All Sessions Complete

1. **Collect artifacts**:
   ```bash
   cd ~/jcaldwell-labs-coordination
   git pull
   ls -la reports/      # All improvement reports
   ls -la sessions/     # All context exports
   ```

2. **Review manifest**:
   ```bash
   cat PARALLEL-SESSION-MANIFEST.md
   # Verify all repos show "completed"
   ```

3. **Run validation** (when script is created):
   ```bash
   ./scripts/validate-phase2.sh
   ```

4. **Generate summary** (when script is created):
   ```bash
   ./scripts/generate-phase2-summary.sh > PHASE2-SUMMARY.md
   ```

5. **Human review**:
   - Read all improvement reports
   - Review all PRs
   - Check for unexpected issues
   - Approve or request changes

6. **Phase 2 sign-off**:
   - All items addressed or documented
   - All PRs reviewed
   - Summary approved
   - Ready for Phase 3

---

## Troubleshooting

### "Session doesn't understand the prompt"

Make sure you:
1. Pasted the **entire** prompt file
2. Are in the **correct repository**
3. Waited for Claude to fully load

### "Manifest has conflicts"

Sessions will handle this:
1. Pull latest manifest
2. Resolve conflicts (usually just both changes)
3. Push again

### "Session exceeded time budget"

This is okay:
- Session will document remaining work
- Create GitHub issues for follow-up
- Complete what's possible in time box
- Mark session as complete with notes

### "Critical blocker found"

Session will:
- Document blocker in improvement report
- Update manifest with blocker note
- Create GitHub issue
- Complete other checklist items
- Notify via manifest

---

## Success Metrics

Phase 2 is successful when:

- [ ] All 9 repositories processed
- [ ] All improvement reports written
- [ ] All PRs created and reviewed
- [ ] All tests passing
- [ ] Documentation standards met
- [ ] No critical blockers
- [ ] Human review approved

---

## Questions?

Create an issue in the jcaldwell-labs/jcaldwell-labs coordination repository.

---

**Last Updated**: 2025-11-22
**Status**: Ready for Phase 2 launch
**Prerequisites**: Phase 1 must be complete
