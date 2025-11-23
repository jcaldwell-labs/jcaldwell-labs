# GitHub Project Board Setup Guide

**Purpose**: Track Phase 3 progress across 4 sub-phases and 9 repositories

**Created**: 2025-11-23 (Phase 3 prerequisites)

---

## Quick Setup

### 1. Create Project

1. Go to https://github.com/orgs/jcaldwell-labs/projects
2. Click "New project"
3. **Name**: "Phase 3: Documentation Excellence"
4. **Template**: "Board" (kanban-style)
5. Click "Create project"

### 2. Configure Columns

Create these columns (in order):

| Column | Purpose |
|--------|---------|
| **Backlog** | All Phase 3 tasks not yet started |
| **Phase 3a: In Progress** | Active 3a tasks (Documentation) |
| **Phase 3b: In Progress** | Active 3b tasks (CLI Integration) |
| **Phase 3c: In Progress** | Active 3c tasks (Testing) |
| **Phase 3d: In Progress** | Active 3d tasks (Polish) |
| **Blocked** | Tasks waiting on external dependency |
| **Needs Review** | PRs awaiting owner review |
| **Done** | Completed tasks |

### 3. Add Custom Fields

**Add these fields to track metadata:**

| Field Name | Type | Values |
|-----------|------|--------|
| Repository | Single select | fintrack, boxes-live, terminal-stars, my-context, tario, adventure-engine-v2, smartterm-prototype, atari-style, .github |
| Sub-Phase | Single select | 3a, 3b, 3c, 3d |
| Session ID | Text | (e.g., "phase3a-fintrack-session1") |
| PR Number | Number | GitHub PR number |
| Status | Single select | not_started, in_progress, needs_handoff, blocked, escalated, completed |
| Priority | Single select | P0 (Critical), P1 (High), P2 (Medium), P3 (Low) |

### 4. Create Automation Rules

**Set up these automations:**

1. **Auto-move to "Needs Review"**:
   - Trigger: PR created
   - Action: Move to "Needs Review" column

2. **Auto-move to "Done"**:
   - Trigger: PR merged
   - Action: Move to "Done" column
   - Set Status field to "completed"

3. **Auto-archive on close**:
   - Trigger: Issue/PR closed
   - Action: Archive item

---

## Initial Board Population

### Phase 3a Tasks (Documentation - Week 1)

Create these issues/cards:

**Repository-specific tasks** (9 cards):
- [ ] fintrack: Phase 3a Documentation
- [ ] boxes-live: Phase 3a Documentation
- [ ] terminal-stars: Phase 3a Documentation
- [ ] my-context: Phase 3a Documentation
- [ ] tario: Phase 3a Documentation
- [ ] adventure-engine-v2: Phase 3a Documentation
- [ ] smartterm-prototype: Phase 3a Documentation
- [ ] atari-style: Phase 3a Documentation
- [ ] .github: Phase 3a Documentation

**Cross-project tasks** (3 cards):
- [ ] Create documentation style guide
- [ ] Set up documentation templates
- [ ] Review all CLAUDE.md files for consistency

### Phase 3b Tasks (CLI Integration - Week 2)

- [ ] my-context: Phase 3b CLI Integration (my-context skill integration)
- [ ] fintrack: Phase 3b CLI Integration
- [ ] boxes-live: Phase 3b CLI Integration
- [ ] terminal-stars: Phase 3b CLI Integration
- [ ] tario: Phase 3b CLI Integration
- [ ] adventure-engine-v2: Phase 3b CLI Integration
- [ ] smartterm-prototype: Phase 3b Terminal UI improvements
- [ ] Cross-project: Verify CLI consistency

### Phase 3c Tasks (Testing - Week 3)

- [ ] fintrack: Phase 3c Testing improvements
- [ ] boxes-live: Phase 3c Testing coverage
- [ ] terminal-stars: Phase 3c Testing coverage
- [ ] my-context: Phase 3c Testing coverage
- [ ] tario: Phase 3c Testing coverage
- [ ] adventure-engine-v2: Phase 3c Testing coverage
- [ ] smartterm-prototype: Phase 3c Testing coverage
- [ ] Cross-project: Test coverage report

### Phase 3d Tasks (Polish - Week 4)

- [ ] Organization README polish
- [ ] Project comparison documentation
- [ ] Cross-repository consistency check
- [ ] Final quality audit
- [ ] Phase 3 completion report

---

## Using the Board

### Daily Operations

**Starting work on a task:**
1. Drag card from "Backlog" to appropriate "In Progress" column
2. Set "Session ID" field
3. Update "Status" to "in_progress"
4. Update PARALLEL-SESSION-MANIFEST.md

**Completing a task:**
1. Create PR
2. Card auto-moves to "Needs Review"
3. Set "PR Number" field
4. Wait for owner review and merge
5. On merge, card auto-moves to "Done"

**If blocked:**
1. Drag to "Blocked" column
2. Set "Status" to "blocked" or "escalated"
3. Add comment explaining blocker
4. Follow ESCALATION-PROTOCOL.md

**If needs handoff:**
1. Update "Status" to "needs_handoff"
2. Create handoff doc in `sessions/`
3. Add comment with handoff doc path

### Views to Create

**Create these filtered views for easy tracking:**

1. **Phase 3a View**:
   - Filter: Sub-Phase = "3a"
   - Sort by: Priority, Repository

2. **Phase 3b View**:
   - Filter: Sub-Phase = "3b"
   - Sort by: Priority, Repository

3. **Phase 3c View**:
   - Filter: Sub-Phase = "3c"
   - Sort by: Priority, Repository

4. **Phase 3d View**:
   - Filter: Sub-Phase = "3d"
   - Sort by: Priority

5. **My Work** (per-repository view):
   - Filter: Repository = [your repo]
   - Group by: Sub-Phase

6. **All Blockers**:
   - Filter: Status = "blocked" OR Status = "escalated"
   - Sort by: Priority

---

## Integration with Manifest

The GitHub Project board and PARALLEL-SESSION-MANIFEST.md should stay in sync:

**Project Board → Manifest:**
- When you move a card to "In Progress", update manifest status
- When you complete a card, update manifest with PR and report

**Manifest → Project Board:**
- Manifest is source of truth for session IDs
- Manifest tracks completion dates
- Manifest links to improvement reports

---

## Success Metrics

Track these on the project board:

- **Velocity**: Cards completed per week
- **Cycle time**: Time from "In Progress" to "Done"
- **Blocker rate**: % of cards that become blocked
- **Handoff rate**: % of cards that need handoff
- **PR merge rate**: % of PRs merged vs. closed

---

## Alternative: Manual Tracking

If GitHub Projects proves too complex, you can track Phase 3 using:

1. **PARALLEL-SESSION-MANIFEST.md** (primary tracking)
2. **GitHub Issues** (one per repository per sub-phase)
3. **GitHub Milestones**:
   - Milestone: "Phase 3a - Documentation"
   - Milestone: "Phase 3b - CLI Integration"
   - Milestone: "Phase 3c - Testing"
   - Milestone: "Phase 3d - Polish"

---

## Next Steps

1. [ ] Create the project board following this guide
2. [ ] Populate initial tasks (at least Phase 3a)
3. [ ] Configure custom fields
4. [ ] Set up automation rules
5. [ ] Create filtered views
6. [ ] Link from README.md

**When ready to launch Phase 3a**, all tracking infrastructure will be in place!

---

**Guide Version**: 1.0
**Created**: 2025-11-23
**For**: Phase 3 - Documentation Excellence
