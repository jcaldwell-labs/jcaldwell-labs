# Session Handoff Protocol

**Purpose**: Clear process for transferring incomplete work to another session or person

**Created**: 2025-11-23 (from Phase 2 lessons learned)

**Problem Solved**: Phase 2 had no structured way to hand off work when sessions couldn't complete tasks, leading to unclear state and difficulty resuming work.

---

## When to Use This Protocol

**Use handoff protocol when**:
- Session time budget exhausted before task complete
- Blocker prevents completion (Level 3 escalation)
- Assigned work larger than expected
- Need to switch context urgently
- Resource constraints (API limits, rate limits)
- Multi-part work spanning multiple days

**Do NOT use if**:
- Task is "done done" (see DONE-DEFINITION.md)
- Issue is Level 1 or 2 (quick fixes or document & continue)
- Work can be completed in < 1 hour

---

## Handoff Checklist

### Phase 1: Prepare Current State

#### 1.1 Save All Local Work
```bash
# Commit all changes (even WIP)
git add -A
git commit -m "wip: handoff checkpoint - [brief status]

Current status:
- Completed: [what's done]
- In progress: [what's started but not finished]
- Not started: [what hasn't been attempted]

Next steps: [what needs to happen next]"

# Push to remote
git push origin $(git branch --show-current)
```

#### 1.2 Document Environment State
Create `HANDOFF-STATE.md` in repository root:

```markdown
# Session Handoff State

**Date**: [YYYY-MM-DD HH:MM]
**Session ID**: [session identifier]
**Branch**: [branch-name]
**Status**: [% complete]

## Current Work
**Task**: [task name from roadmap]
**Goal**: [what this task aims to accomplish]

## What's Complete ✅
- [Completed item 1]
- [Completed item 2]
- [Completed item 3]

**Files changed**:
- `path/to/file1.go` - [description of changes]
- `path/to/file2.c` - [description of changes]

## What's In Progress ⏳
- [Started item 1] - Status: [% done, what's left]
- [Started item 2] - Status: [% done, what's left]

**Current files being edited**:
- `path/to/file3.go` - [what needs to be finished]

## What's Not Started ⏸️
- [Pending item 1]
- [Pending item 2]

## Blockers 🚨
[If any - link to escalation issues]

## Environment Setup
**Dependencies installed**:
- [dependency 1] - version [X.Y.Z]
- [dependency 2] - version [X.Y.Z]

**Environment variables**:
```bash
export VAR1=value1
export VAR2=value2
```

**Database state**:
- Database: [name]
- Migrations run: [yes/no, which ones]
- Test data: [present/absent, how to recreate]

## Build/Test Status
**Last successful build**: [timestamp]
**Last successful test run**: [timestamp]
**Known failures**: [any failing tests/builds]

## Next Steps
1. [First thing to do when resuming]
2. [Second thing]
3. [Third thing]

## Time Invested
Total time on this task so far: [X] hours

Breakdown:
- Setup/research: [Y] hours
- Implementation: [Z] hours
- Debugging: [W] hours

## Commands to Resume
```bash
# Clone and setup (if new environment)
git clone https://github.com/jcaldwell-labs/[repo].git
cd [repo]
git checkout [branch-name]

# Install dependencies
[dependency install commands]

# Verify state
make build
make test

# Continue work
[specific next commands]
```

## Notes
[Any additional context, decisions made, approaches tried, etc.]
```

#### 1.3 Export my-context Session
```bash
# Export session with handoff tag
my-context note "HANDOFF: Session incomplete, handing off work"
my-context note "Status: [% complete]"
my-context note "Next: [immediate next steps]"
my-context export [session-name] > sessions/[session-name]-HANDOFF.md
```

### Phase 2: Update Tracking

#### 2.1 Update Manifest
```markdown
| Repository | Status | Session ID | Started | Handoff | PR | Report | Notes |
|-----------|--------|-----------|---------|---------|----|----|-------|
| repo-name | needs_handoff | session-123 | 2025-11-23 | 2025-11-23 | #45 | partial | See HANDOFF-STATE.md |
```

#### 2.2 Create Handoff Issue
```markdown
# [Handoff Required] [Task Name]

## Session Information
**Original Session**: [session ID]
**Started**: [date]
**Time Invested**: [X] hours
**Current Branch**: [branch-name]
**Current PR**: #[number] (if created)

## Completion Status
**Overall**: [XX]% complete

**Completed**:
- [Item 1]
- [Item 2]

**In Progress**:
- [Item 3] - [% done, what's left]

**Not Started**:
- [Item 4]
- [Item 5]

## Handoff Documentation
- **State Document**: [link to HANDOFF-STATE.md in branch]
- **my-context Export**: [link to sessions/[name]-HANDOFF.md]
- **Branch**: [branch-name]
- **Commit**: [latest commit hash]

## Why Handoff Needed
[Reason - time budget exhausted, blocker, context switch, etc.]

## Blocker (if applicable)
[Link to blocker issue if this is Level 3 escalation]

## Next Steps for Resuming
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Estimated Time to Complete
Remaining work: [Y] hours estimated

## Labels
`needs-handoff`, `[task-type]`, `[priority]`
```

### Phase 3: Cleanup Before Handoff

#### 3.1 Push All Work
```bash
# Ensure everything is pushed
git push origin $(git branch --show-current)

# Verify nothing left locally
git status  # Should show clean
```

#### 3.2 No Local-Only State
**Ensure**:
- No uncommitted changes
- No untracked files with work
- No local database state that can't be recreated
- No local config files required to build/test

**If local-only state exists**:
- Document it in HANDOFF-STATE.md
- Provide recreation commands
- Or push it to the branch

#### 3.3 Verify Branch is Usable
```bash
# Test that someone else can use this branch
cd /tmp
git clone [repo-url] test-handoff
cd test-handoff
git checkout [handoff-branch]

# Can they build?
make build

# Can they run tests?
make test

# If not, document missing steps in HANDOFF-STATE.md
```

---

## Resuming from Handoff

### For the Resuming Session/Person

#### Step 1: Read Handoff Documentation
1. Read HANDOFF-STATE.md in branch
2. Read my-context export from sessions/
3. Read handoff GitHub issue
4. Understand what's done vs what's left

#### Step 2: Set Up Environment
```bash
# Clone and checkout
git clone [repo-url]
cd [repo]
git checkout [handoff-branch]

# Follow setup from HANDOFF-STATE.md
[run dependency install commands]
[set environment variables]
[recreate database state if needed]
```

#### Step 3: Verify Current State
```bash
# Does it build?
make clean && make build

# Do tests pass?
make test

# What's the diff?
git diff origin/main

# Read the code changes
[review changed files]
```

#### Step 4: Update Tracking
```bash
# Start new my-context session or continue existing
my-context note "HANDOFF-RESUME: Taking over from [previous-session-id]"
my-context note "Reviewed: HANDOFF-STATE.md, previous work understood"
my-context note "Status: Starting from [% complete]"
```

#### Step 5: Continue Work
- Follow "Next Steps" from HANDOFF-STATE.md
- Apply pre-PR validation before creating PR
- Use escalation protocol if issues arise
- Aim for "done done" completion

#### Step 6: Close Handoff Loop
When complete:
1. Update handoff issue: "Completed by [new-session-id]"
2. Close handoff issue
3. Update manifest: needs_handoff → completed
4. Acknowledge previous session's work in PR description

---

## Handoff Types

### Type 1: Time Budget Exhaustion
**Scenario**: Session ran out of time, work incomplete but progressing well

**Characteristics**:
- No blockers
- Clear path forward
- Just needs more time

**Handoff Emphasis**:
- What works so far
- Next concrete steps
- Estimated time remaining

**Resume Priority**: Normal

### Type 2: Blocker Handoff
**Scenario**: Hit Level 3 blocker, moving to other work while waiting for resolution

**Characteristics**:
- Specific issue blocking progress
- Escalation issue created
- Alternative work available

**Handoff Emphasis**:
- What the blocker is
- What was tried
- What's needed to unblock
- Alternative work being pursued

**Resume Priority**: After blocker resolved

### Type 3: Rethink Required
**Scenario**: Current approach isn't working, needs different strategy

**Characteristics**:
- Multiple failed attempts
- Architectural questions
- Design decisions needed

**Handoff Emphasis**:
- What was tried and why it didn't work
- Alternative approaches to consider
- Decision questions that need answers

**Resume Priority**: After design review

### Type 4: Context Switch
**Scenario**: Need to work on something else urgently, will resume later

**Characteristics**:
- Work is progressing fine
- No blockers
- Just switching priority

**Handoff Emphasis**:
- Quick resume instructions
- Minimal setup needed
- Can pick up easily

**Resume Priority**: When ready to return

---

## Phase 2 Examples

### Example 1: What Handoff Would Have Prevented
**Situation**: fintrack PR #9 became too complex

**What Happened**:
- Session created large PR with usage testing feature
- CI failed on security scan
- Session spent 7+ commits trying to fix
- Eventually closed PR

**What Handoff Would Have Done**:
After 3rd security scan iteration (60 min invested):
1. Create HANDOFF-STATE.md documenting:
   - Feature complete but security scan false positive
   - Attempts 1-3 tried and failed
   - Need to either fix workflow or escalate
2. Create handoff issue with blocker details
3. Move to other work
4. Resuming session fixes workflow itself (takes 30 min)
5. Resume original work with fixed workflow

**Benefit**: Saved hours of wasted commits, clearer history

### Example 2: Multi-Day Work
**Situation**: Large task like boxes-live improvements

**Good Approach with Handoff**:
- Day 1 Session:
  - Complete PRs 1-3 (docs, CI, templates)
  - Create HANDOFF-STATE for remaining work
  - Export my-context
  - Update manifest: 60% complete
- Day 2 Session:
  - Resume from handoff
  - Complete PRs 4-5
  - Mark "done done"

**Benefit**: Clean break between sessions, no work lost, clear progress tracking

---

## Key Principles

### Principle 1: Make It Easy to Resume
**Write handoff docs for your future self**

Assume the person resuming knows nothing about what you did. Document everything.

### Principle 2: Push Everything
**Don't leave work on your local machine**

Everything must be in git, committed and pushed. No exceptions.

### Principle 3: Handoff is Normal
**Don't feel bad about handing off**

Complex work often requires multiple sessions. Proper handoff is professional.

### Principle 4: Close the Loop
**When resuming, acknowledge handoff**

Credit previous session's work. Update handoff issue. Complete the circle.

---

## Integration with Phase 3

**Phase 3 Requirements**:

1. **Time-boxed sessions**: Each session has max 8-hour budget
2. **Handoff required** if work extends beyond one session
3. **No work left in limbo**: Every incomplete task has handoff docs
4. **Manifest tracks handoffs**: "needs_handoff" status with links

**Session prompts must include**:
- Handoff protocol reference
- HANDOFF-STATE.md template
- Time budget with handoff trigger (e.g., at 7-hour mark, prepare handoff)

**Success metrics**:
- 100% of handed-off work has complete documentation
- Zero instances of work lost in handoff
- Average resume time < 30 minutes (good handoff docs enable fast resume)

---

**Version**: 1.0
**Created**: 2025-11-23
**Author**: Phase 2 retrospective learnings
**Status**: Active for Phase 3 and beyond
**Related**: ESCALATION-PROTOCOL.md, DONE-DEFINITION.md
