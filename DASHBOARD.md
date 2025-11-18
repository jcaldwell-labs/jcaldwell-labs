# JCaldwell Labs - Project Dashboard

**Last Updated:** 2025-11-18 13:10 UTC
**Context:** jcaldwell-labs-audit-2025-11-18 (db:jcaldwell_labs)

---

## Quick Status Overview

| Project | Language | Status | Open PRs | Priority | Health |
|---------|----------|--------|----------|----------|--------|
| **terminal-stars** | C | Feature Development | 1 | HIGH | 🟡 PR Review Needed |
| **fintrack** | Go | CLAUDE.md Needed | 1 | HIGH | 🟡 Docs Incomplete |
| **smartterm-prototype** | C | CLAUDE.md Needed | 1 | MEDIUM | 🟡 Docs Incomplete |
| **.github** | Markdown | Enhancement PR | 1 | LOW | 🟡 PR Review Needed |
| **boxes-live** | C | Ready | 0 | HIGH | 🟢 Active Development |
| **tario** | C | Ready | 0 | MEDIUM | 🟢 Active Development |
| **adventure-engine-v2** | C | Ready | 0 | MEDIUM | 🟢 Active Development |
| **my-context** | Go | Production | 0 | HIGH | 🟢 Production Ready |

**Summary:** 4 open PRs requiring review, 4 projects ready for feature development, 3 projects in documentation phase.

---

## Open PRs Requiring Action

### PR #5: terminal-stars - Add horizon and disable star field
**URL:** https://github.com/jcaldwell-labs/terminal-stars/pull/5
**Branch:** `claude/add-horizon-disable-stars-01HnbVLXFqiYxTPRDs5xhJqj`
**Author:** jcaldwell1066
**Status:** OPEN (Updated 2025-11-18)
**Draft:** No

**Description:**
Implemented complete skeet shooting game mode with:
- New MODE_SKEET game mode
- Clay pigeon physics with arc trajectories
- Horizon rendering at 2/3 screen height
- Target reticle system
- Collision detection between missiles and pigeons
- Progressive difficulty system (Easy → Medium → Hard → Expert)
- Comprehensive HUD (score, accuracy, hits, misses, difficulty)
- Disabled starfield in skeet mode

**Impact:** Adds entirely new game mode to the project

**Next Actions:**
1. Review code quality and architecture
2. Test gameplay mechanics
3. Verify build succeeds
4. Check for any TODO comments or incomplete features
5. Merge or request changes

**Follow-up Prompt:**
```
Review and test PR #5 in jcaldwell-labs/terminal-stars.
Clone the PR branch, build it, test the skeet shooting mode.
Check code quality, architecture consistency, and test coverage.
Provide detailed review comments or approve for merge.
```

---

### PR #3: fintrack - Write a CLAUDE.md
**URL:** https://github.com/jcaldwell-labs/fintrack/pull/3
**Branch:** `claude/claude-md-mi3omy40n50tuoll-01K5yjQtmtgJccNrJXS6rbxo`
**Author:** jcaldwell1066
**Status:** OPEN (Updated 2025-11-18)
**Draft:** No

**Description:**
Adds CLAUDE.md documentation for the fintrack repository to guide AI agents.

**Impact:** Improves AI agent productivity when working on fintrack

**Next Actions:**
1. Review CLAUDE.md content for completeness
2. Verify it follows the template and includes:
   - Build/test commands
   - Architecture overview
   - Development workflow
   - Database setup
3. Merge if complete, request revisions if incomplete

**Follow-up Prompt:**
```
Review PR #3 in jcaldwell-labs/fintrack (CLAUDE.md addition).
Verify the documentation is comprehensive and follows best practices.
Check that it includes: build commands, test commands, architecture,
database setup, and development workflow guidance.
Approve for merge or suggest improvements.
```

---

### PR #2: smartterm-prototype - Write a CLAUDE.md
**URL:** https://github.com/jcaldwell-labs/smartterm-prototype/pull/2
**Branch:** `claude/claude-md-mi3opz4monq14xm7-011dWrWja2WYnrVXZweJGhpK`
**Author:** jcaldwell1066
**Status:** OPEN (Updated 2025-11-18)
**Draft:** No

**Description:**
Adds CLAUDE.md documentation for the smartterm-prototype repository.

**Impact:** Improves AI agent understanding of the POC and decision points

**Next Actions:**
1. Review CLAUDE.md content
2. Ensure it addresses the "library vs minimal extraction" decision point
3. Include architecture of the prototype components
4. Merge if comprehensive

**Follow-up Prompt:**
```
Review PR #2 in jcaldwell-labs/smartterm-prototype (CLAUDE.md).
This is a POC at a decision point (full library vs minimal extraction).
Verify the CLAUDE.md explains the prototype's purpose, architecture,
and the decision that needs to be made. Approve or suggest improvements.
```

---

### PR #1: .github - Improve session persistence and skill retention
**URL:** https://github.com/jcaldwell-labs/.github/pull/1
**Branch:** `claude/improve-session-persistence-0157xe58Dt1LtMcooBaiUYnr`
**Author:** jcaldwell1066
**Status:** OPEN (Updated 2025-11-18)
**Draft:** No

**Description:**
Enhancements to organization-level documentation for improving session persistence and skill retention.

**Impact:** Better documentation for organization-wide practices

**Next Actions:**
1. Review proposed changes to .github profile
2. Verify accuracy and clarity
3. Merge if improvements are valuable

**Follow-up Prompt:**
```
Review PR #1 in jcaldwell-labs/.github repository.
This PR improves session persistence and skill retention documentation.
Verify the changes improve organization-level guidance and merge if approved.
```

---

## Project Deep Dives

### 1. terminal-stars

**Repository:** https://github.com/jcaldwell-labs/terminal-stars
**Language:** C
**Last Update:** 2025-11-18
**Status:** Active Feature Development

#### Current State
- Has working skeet shooting game mode in PR #5
- Starfield visualization core exists
- ncurses-based terminal rendering

#### Open Work
- **PR #5** - Skeet shooting mode (needs review)

#### Next Tasks
1. **Immediate:** Review and merge PR #5
2. **Short-term:** Implement core starfield visualization
   - Basic star particle system
   - Frame buffer for smooth rendering
   - Linear motion effect
   - 60fps target
3. **Medium-term:** Add more visual effects
   - Spiral motion
   - Warp speed
   - Tunnel effect
   - Wave patterns

#### Suggested Agent Session
**Context Partition:** `db:terminal_stars_dev`
**Prompt:**
```
Review and merge PR #5 in terminal-stars, then implement the core
starfield visualization with frame buffering and smooth 60fps rendering.
Create comprehensive tests and update documentation.
```

---

### 2. fintrack

**Repository:** https://github.com/jcaldwell-labs/fintrack
**Language:** Go
**Last Update:** 2025-11-17
**Status:** MVP Phase 1 - CLAUDE.md Needed

#### Current State
- Account CRUD operations complete with tests
- PostgreSQL backend with GORM
- Unit tests passing (7/7)
- Database schema established

#### Open Work
- **PR #3** - CLAUDE.md (needs review/merge)

#### Next Tasks
1. **Immediate:** Review and merge CLAUDE.md PR #3
2. **High Priority:** Transaction management
   - Design Transaction model
   - Implement CRUD operations
   - Link to accounts
   - Auto-update balances
3. **Medium Priority:** CSV import
   - Bank statement parsing
   - Duplicate detection
   - Format auto-detection

#### Suggested Agent Session
**Context Partition:** `db:fintrack_dev`
**Prompt:**
```
Merge PR #3 in fintrack, then implement transaction management:
- Transaction model (Date, Amount, Description, FromAccount, ToAccount, Category)
- TransactionRepository with full CRUD
- Unit tests following existing patterns
- Auto-update account balances on transaction create/delete
Track work in db:fintrack_dev partition.
```

---

### 3. smartterm-prototype

**Repository:** https://github.com/jcaldwell-labs/smartterm-prototype
**Language:** C
**Last Update:** 2025-11-17
**Status:** POC Complete - Decision Point

#### Current State
- Working prototype of Claude Code-inspired terminal UI
- Scrolling output, context awareness, status bar
- At decision point: full library vs minimal extraction

#### Open Work
- **PR #2** - CLAUDE.md (needs review/merge)

#### Next Tasks
1. **Immediate:** Review and merge CLAUDE.md PR #2
2. **Critical Decision:** Determine extraction strategy
   - Analyze reusability across projects
   - Estimate effort for full library vs minimal
   - Make architectural decision
3. **Implementation:** Based on decision
   - Option A: Extract minimal components (scrolling buffer, status bar)
   - Option B: Design full library architecture

#### Suggested Agent Session
**Context Partition:** `db:smartterm_dev`
**Prompt:**
```
Merge PR #2 in smartterm-prototype, then perform decision analysis:
Analyze the prototype and recommend full library vs minimal extraction.
Consider reusability across boxes-live, terminal-stars, tario projects.
Provide detailed comparison with effort estimates and recommendation.
Document in decision-analysis.md file.
```

---

### 4. .github (Organization Profile)

**Repository:** https://github.com/jcaldwell-labs/.github
**Language:** Markdown
**Last Update:** 2025-11-17
**Status:** Maintained

#### Current State
- Organization profile README exists
- Community health files present

#### Open Work
- **PR #1** - Session persistence improvements (needs review)

#### Next Tasks
1. **Immediate:** Review and merge PR #1
2. **Ongoing:** Update as organization grows
3. **Future:** Add CONTRIBUTING.md org-wide

#### Suggested Action
```
Review and merge PR #1 in .github repository.
Verify the session persistence documentation improvements are accurate.
```

---

### 5. boxes-live

**Repository:** https://github.com/jcaldwell-labs/boxes-live
**Language:** C
**Last Update:** 2025-11-17
**Status:** MVP Complete - Ready for Features

#### Current State
- Working pan & zoom canvas
- Box rendering with box-drawing characters
- Viewport system operational
- Terminal resize support

#### Open Work
- None (ready for new features)

#### Next Tasks
1. **High Priority:** Canvas persistence
   - Save to JSON
   - Load from JSON
   - Multiple canvases in memory
   - Canvas metadata
2. **High Priority:** Drawing tools
   - Line drawing
   - Text annotations
   - Arrow connections
   - Freehand mode

#### Suggested Agent Session
**Context Partition:** `db:boxes_live_dev`
**Prompt:**
```
Implement canvas persistence for boxes-live:
- Save canvas to JSON file (':s filename.json')
- Load canvas from JSON (':l filename.json')
- Support multiple canvases (':n canvas-name')
- Add canvas metadata (name, created, modified timestamps)
Use MY_CONTEXT_HOME=db:boxes_live_dev for tracking.
```

---

### 6. tario

**Repository:** https://github.com/jcaldwell-labs/tario
**Language:** C
**Last Update:** 2025-11-18
**Status:** Active Development - Ready for Features

#### Current State
- ASCII side-scrolling platformer
- ANSI escape codes for rendering
- Basic physics implemented
- Initial levels exist

#### Open Work
- None (ready for new features)

#### Next Tasks
1. **High Priority:** Enemy AI
   - Patrol patterns
   - Chase behavior
   - Jump mechanics for enemies
   - Different enemy types
2. **Medium Priority:** Level editor
   - Place tiles (platforms, enemies, coins)
   - Save/load levels as JSON
3. **Medium Priority:** Power-ups
   - Double jump
   - Speed boost
   - Invincibility

#### Suggested Agent Session
**Context Partition:** `db:tario_dev`
**Prompt:**
```
Implement enemy AI for tario platformer:
- Patrol pattern (move back and forth)
- Chase player when in range
- Enemy can jump to reach platforms
- Multiple enemy types (fast, slow, flying)
- Collision detection with player
Track work in db:tario_dev partition.
```

---

### 7. adventure-engine-v2

**Repository:** https://github.com/jcaldwell-labs/adventure-engine-v2
**Language:** C
**Last Update:** 2025-11-17
**Status:** Active Development - DSL Design Phase

#### Current State
- Text-based adventure engine
- Smart terminal UI framework
- Path B→A MVP approach

#### Open Work
- None (ready for DSL implementation)

#### Next Tasks
1. **High Priority:** DSL Design & Parser
   - Define adventure DSL syntax (YAML or custom)
   - Implement parser
   - Room/item/NPC data structures
   - Game state machine
2. **High Priority:** Sample Adventure
   - 5-10 room demo adventure
   - Validates DSL design
   - Serves as documentation

#### Suggested Agent Session
**Context Partition:** `db:adventure_v2_dev`
**Prompt:**
```
Design and implement the adventure DSL for adventure-engine-v2:
- Design DSL syntax for rooms, items, NPCs, actions (recommend YAML)
- Implement parser to load DSL into game structures
- Build game state machine for navigation and interactions
- Create sample 5-room adventure to validate the DSL
Track decisions in db:adventure_v2_dev partition.
```

---

### 8. my-context

**Repository:** https://github.com/jcaldwell-labs/my-context
**Language:** Go
**Last Update:** 2025-11-17
**Status:** Production Ready - Enhancement Phase

#### Current State
- Fully functional context management CLI
- PostgreSQL database backend operational
- Cross-platform (Linux, macOS, Windows via WSL)
- Comprehensive features: notes, files, export, archive, signals
- Database partition support

#### Open Work
- None (production stable)

#### Next Tasks
1. **High Value:** Advanced query features
   - Full-text note search
   - Time-range filtering (--since, --until)
   - Multiple export formats (JSON, CSV, HTML)
   - Context relationship graphs
2. **Medium Value:** Team features
   - Shared contexts
   - Permissions (read/write/admin)
   - Activity logs
   - User mentions in notes
3. **Medium Value:** Integrations
   - Git hooks
   - Issue tracker linking
   - Export plugins (Notion, Obsidian)

#### Suggested Agent Session
**Context Partition:** `db:my_context_dev`
**Prompt:**
```
Implement advanced query features for my-context:
- Full-text search: --note-search flag searches all note content
- Time filters: --since and --until for date ranges
- Export formats: --format json|csv|html|md
- Relationship graph: --graph shows parent/child context relationships
Add comprehensive tests, update docs. Use db:my_context_dev.
```

---

## Active Context Sessions

**Current Partition:** `db:jcaldwell_labs`
**Active Session:** `jcaldwell-labs-audit-2025-11-18`
**Status:** Running (started 2025-11-18 12:49:25)

### Session Notes
1. Comprehensive audit of all 8 repositories
2. Identified 4 open PRs requiring review
3. Created CLAUDE.md for coordination workspace
4. Generated NEXT-STEPS.md with parallel work opportunities
5. Created this dashboard report

### Recommended Next Sessions

#### Immediate (Today)
1. **PR Review Session** - `db:jcaldwell_labs`
   - Review and merge all 4 open PRs
   - Test terminal-stars skeet mode
   - Verify CLAUDE.md completeness

#### This Week
2. **fintrack Transactions** - `db:fintrack_dev`
3. **boxes-live Persistence** - `db:boxes_live_dev`
4. **my-context Advanced Queries** - `db:my_context_dev`

#### Next Week
5. **terminal-stars Core Visualization** - `db:terminal_stars_dev`
6. **tario Enemy AI** - `db:tario_dev`
7. **adventure-engine DSL** - `db:adventure_v2_dev`

---

## Coordination Checklist

### Daily Tasks
- [ ] Check for new PRs across all repos
- [ ] Review PR comments and CI/CD status
- [ ] Update this dashboard
- [ ] Export active my-context sessions

### Weekly Tasks
- [ ] Review project health metrics
- [ ] Identify features for parallel development
- [ ] Update NEXT-STEPS.md with new priorities
- [ ] Audit open issues (when issues exist)

### Monthly Tasks
- [ ] Review GitHub stars/engagement metrics
- [ ] Evaluate project priorities
- [ ] Update organization README
- [ ] Create progress report

---

## Quick Commands Reference

### Check All PRs
```bash
cd ~/projects/jcaldwell-labs
/tmp/check-prs.sh  # Script created during this audit
```

### Start Coordination Session
```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "coordination-$(date +%Y-%m-%d)"
```

### Start Project-Specific Session
```bash
# Replace <project> with: fintrack, boxes_live, terminal_stars, etc.
export MY_CONTEXT_HOME=db:<project>_dev
my-context start "feature-<name>-$(date +%Y-%m-%d)"
```

### Review PR Locally
```bash
gh pr checkout <number> --repo jcaldwell-labs/<project>
# Build and test
# Review code
gh pr review <number> --repo jcaldwell-labs/<project> --approve
# OR
gh pr review <number> --repo jcaldwell-labs/<project> --request-changes --body "Comments here"
```

---

## Health Metrics

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| **Total Repositories** | 8 | - | ✓ |
| **Open PRs** | 4 | < 5 | 🟡 Review Needed |
| **PRs > 7 days old** | 0 | 0 | ✓ |
| **Projects with CLAUDE.md** | 3/8 | 8/8 | 🟡 In Progress |
| **Projects with Tests** | 2/8 | 8/8 | 🔴 Needs Work |
| **Total Stars** | 0 | 10+ | 🔴 New Org |
| **Days Since Last Commit** | 0 | < 3 | ✓ |
| **Active Development** | 8/8 | 8/8 | ✓ |

---

## Priority Actions (Next 24 Hours)

1. ✅ **DONE:** Complete audit and create dashboard
2. **HIGH:** Review terminal-stars PR #5 (skeet mode)
3. **HIGH:** Review and merge fintrack PR #3 (CLAUDE.md)
4. **HIGH:** Review and merge smartterm-prototype PR #2 (CLAUDE.md)
5. **MEDIUM:** Review .github PR #1
6. **HIGH:** Start fintrack transaction implementation
7. **HIGH:** Start boxes-live persistence
8. **MEDIUM:** Create CLAUDE.md for remaining 5 projects

---

**Generated by:** jcaldwell-labs-audit-2025-11-18 (MY_CONTEXT_HOME=db:jcaldwell_labs)
**Export this session:** `MY_CONTEXT_HOME=db:jcaldwell_labs my-context export jcaldwell-labs-audit-2025-11-18`
