# jcaldwell-labs Coordination Workspace

**Purpose**: Central coordination hub for managing 9 terminal-based open source projects

**Organization**: [github.com/jcaldwell-labs](https://github.com/jcaldwell-labs)

---

## Quick Start

### First Time Here?

1. **New to jcaldwell-labs?**: See [`USER-REGISTRATION.md`](USER-REGISTRATION.md) - How to get started
2. **Read the roadmap**: [`ROADMAP-2025.md`](ROADMAP-2025.md) - Complete improvement plan
3. **Check current status**: Run `./scripts/action-dashboard.sh`
4. **See what needs attention**: Review [`ORGANIZATION-STATUS.md`](ORGANIZATION-STATUS.md)

### Starting Work?

1. **Check which phase we're in**: See [Phases](#phases) below
2. **Follow phase-specific instructions**: See roadmap for current phase
3. **Use coordination tools**: Scripts in `./scripts/`

---

## Repository Structure

This coordination workspace is organized as follows:

```
jcaldwell-labs/
├── docs/              # Protocol documents and guides
│   ├── PR-FAILURE-PROTOCOL.md
│   ├── ESCALATION-PROTOCOL.md
│   ├── INCREMENTAL-MERGE-STRATEGY.md
│   ├── DONE-DEFINITION.md
│   ├── SESSION-HANDOFF-PROTOCOL.md
│   └── GITHUB-PROJECT-SETUP.md
├── scripts/           # Automation and management scripts
│   ├── action-dashboard.sh
│   ├── check-prs.sh
│   ├── pre-pr-check.sh
│   └── generate-improvement-report.sh
├── prompts/           # Session prompts for Phase 3 work
│   ├── PHASE3A-BUILD-SYSTEM-PROMPT.txt
│   ├── PHASE3B-SESSION1-MYCONTEXT-INTEGRATION-PROMPT.txt
│   └── ...
├── reports/           # Auto-generated improvement reports
├── sessions/          # Session handoff documentation
├── repos/             # Cloned project repositories (gitignored)
├── templates/         # Templates for various workflows
├── tools/             # Development and diagnostic tools
├── archive/           # Historical documents
├── Makefile           # Unified build system (Phase 3a)
├── ROADMAP-2025.md    # Complete improvement plan
├── PARALLEL-SESSION-MANIFEST.md  # Session tracking
└── README.md          # This file
```

### Key Directories

- **`docs/`**: Phase 2 and Phase 3 protocol documents - read these before starting work
- **`scripts/`**: Management scripts for PR checks, health monitoring, report generation
- **`prompts/`**: Pre-written session prompts for Phase 3 tasks
- **`reports/`**: Generated improvement reports (one per repository per phase)
- **`sessions/`**: Handoff documentation when work needs to be transferred
- **`repos/`**: Local clones of all 9 organization projects (not tracked in git)

### Important Files

- **`Makefile`**: Unified build system - run `make help` to see available targets
- **`ROADMAP-2025.md`**: Master plan with all phases, tasks, and timelines
- **`PARALLEL-SESSION-MANIFEST.md`**: Tracks which sessions are working on which repos

---

## Projects Under Management

| Repository | Language | Status | Description |
|-----------|----------|--------|-------------|
| [fintrack](https://github.com/jcaldwell-labs/fintrack) | Go | Active | Financial tracking CLI |
| [boxes-live](https://github.com/jcaldwell-labs/boxes-live) | C | Active | Terminal canvas (Miro alternative) |
| [terminal-stars](https://github.com/jcaldwell-labs/terminal-stars) | C | Active | Starfield visualization |
| [my-context](https://github.com/jcaldwell-labs/my-context) | Go | Production | Agent journal and context management |
| [tario](https://github.com/jcaldwell-labs/tario) | C | Active | ASCII platformer game |
| [adventure-engine-v2](https://github.com/jcaldwell-labs/adventure-engine-v2) | C | Active | Text adventure engine |
| [smartterm-prototype](https://github.com/jcaldwell-labs/smartterm-prototype) | C | Active | Terminal UI library |
| [atari-style](https://github.com/jcaldwell-labs/atari-style) | Python | Active | Terminal arcade games |
| [.github](https://github.com/jcaldwell-labs/.github) | Markdown | Active | Organization profile |

**Total**: 9 repositories (5 C, 2 Go, 1 Python, 1 Markdown)

---

## Phases

### ✅ Phase 0: Pre-Work (Complete)

**Status**: Complete
**Deliverables**: Roadmap, coordination framework, validation system

**Key Documents**:
- [`ROADMAP-2025.md`](ROADMAP-2025.md) - Complete 4-phase improvement plan
- [`PARALLEL-SESSION-GUIDE.md`](PARALLEL-SESSION-GUIDE.md) - Session coordination
- [`VALIDATION-CHECKLIST.md`](VALIDATION-CHECKLIST.md) - Quality gates
- [`PHASE0-COMPLETION-SUMMARY.md`](PHASE0-COMPLETION-SUMMARY.md) - What we accomplished

### 🔄 Phase 1: Foundation (Current)

**Status**: Ready to start
**Duration**: 1-2 sessions (8 hours estimated)

**Objectives**:
1. System reboot (clear stuck process PID 1284)
2. Review and merge 7 ready PRs
3. Sync all repositories
4. Clone missing repos
5. Baseline health check

**Start Here**: See [`ROADMAP-2025.md`](ROADMAP-2025.md) → Phase 1

### ⏸️ Phase 2: Repository Improvements (Pending)

**Status**: Waiting for Phase 1 completion
**Duration**: 1-2 weeks with parallel sessions

**Objectives**: Improve all 9 repos with standard quality enhancements

**Strategy**: Deploy 5-7 parallel Claude Code sessions

**Coordination**: Via [`PARALLEL-SESSION-MANIFEST.md`](PARALLEL-SESSION-MANIFEST.md)

### ⏸️ Phase 3: Cross-Project Integration (Pending)

**Status**: Waiting for Phase 2 completion
**Duration**: 1-2 weeks

**Objectives**: Unified build system, integrations, organization infrastructure

### ⏸️ Phase 4: Continuous Audit (Pending)

**Status**: Waiting for Phase 3 completion
**Duration**: Ongoing

**Objectives**: Automated health monitoring, regular reviews

---

## Coordination Tools

### Management Scripts

Located in `./scripts/`:

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `action-dashboard.sh` | Comprehensive action overview | Start of every session |
| `check-prs.sh` | PR status across all repos | Quick PR check |
| `repo-health.sh` | Local and remote repo status | Before starting work |
| `phase2-rollup.sh` | Validate Phase 2 completion | After all sessions complete |
| `generate-phase2-summary.sh` | Generate executive summary | Phase 2 sign-off |
| `generate-stack-graph.sh` | Visualize stack dependencies | Phase 3b planning, onboarding |

**Run any script**:
```bash
./scripts/action-dashboard.sh
```

### Tracking Files

| File | Purpose |
|------|---------|
| [`ORGANIZATION-STATUS.md`](ORGANIZATION-STATUS.md) | Current state snapshot |
| [`PARALLEL-SESSION-MANIFEST.md`](PARALLEL-SESSION-MANIFEST.md) | Live session tracking |
| [`VALIDATION-CHECKLIST.md`](VALIDATION-CHECKLIST.md) | Phase validation criteria |

### Templates

| Template | Purpose |
|----------|---------|
| `templates/IMPROVEMENT-REPORT-TEMPLATE.md` | Standard session report format |

---

## Directory Structure

```
jcaldwell-labs/
├── README.md                           # This file - start here
├── ROADMAP-2025.md                     # Complete 4-phase plan
├── PARALLEL-SESSION-GUIDE.md           # Parallel session instructions
├── PARALLEL-SESSION-MANIFEST.md        # Live session tracking
├── VALIDATION-CHECKLIST.md             # Quality gates for each phase
├── ORGANIZATION-STATUS.md              # Current state snapshot
├── USB-STUCK-PROCESS-DIAGNOSTIC.md     # Critical atari-style fix
├── PHASE0-COMPLETION-SUMMARY.md        # Phase 0 summary
│
├── scripts/                            # Management and validation scripts
│   ├── action-dashboard.sh
│   ├── check-prs.sh
│   ├── repo-health.sh
│   ├── phase2-rollup.sh
│   └── generate-phase2-summary.sh
│
├── templates/                          # Standard templates
│   └── IMPROVEMENT-REPORT-TEMPLATE.md
│
├── reports/                            # Session improvement reports (Phase 2+)
├── sessions/                           # my-context exports
├── repos/                              # Local clones (gitignored)
└── archive/                            # Historical files
```

---

## Common Workflows

### Check What Needs Attention

```bash
# See everything that needs action
./scripts/action-dashboard.sh

# Just check PRs
./scripts/check-prs.sh

# Just check repo health
./scripts/repo-health.sh
```

### Review a Pull Request

```bash
cd repos/<repo-name>
gh pr checkout <pr-number>
# Review, test, comment
gh pr review <pr-number> --approve
gh pr merge <pr-number>
```

### Sync All Repositories

```bash
cd repos/<repo-name>
git pull origin main
```

### Clone Missing Repository

```bash
gh repo clone jcaldwell-labs/<repo-name> repos/<repo-name>
```

### Start Coordination Session

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "coordination-$(date +%Y-%m-%d)"
my-context note "Your note here"
my-context export > sessions/session-summary.md
```

---

## Key Documents

### Strategic Planning
- **[ROADMAP-2025.md](ROADMAP-2025.md)**: Complete improvement plan (376 lines)
- **[ORGANIZATION-STATUS.md](ORGANIZATION-STATUS.md)**: Current state and immediate actions

### Execution Guides
- **[PARALLEL-SESSION-GUIDE.md](PARALLEL-SESSION-GUIDE.md)**: How to run parallel sessions (681 lines)
- **[VALIDATION-CHECKLIST.md](VALIDATION-CHECKLIST.md)**: Quality gates for each phase (339 lines)

### Reference
- **[USB-STUCK-PROCESS-DIAGNOSTIC.md](USB-STUCK-PROCESS-DIAGNOSTIC.md)**: Critical fix documentation
- **[PHASE0-COMPLETION-SUMMARY.md](PHASE0-COMPLETION-SUMMARY.md)**: What Phase 0 accomplished

---

## Success Metrics

### Current State (as of Phase 0 completion)

- **Repositories**: 9 total
- **Open PRs**: 8 (7 ready, 1 draft)
- **Cloned Locally**: 4/9
- **Behind Remote**: 2 repos
- **Stuck Processes**: 1 (PID 1284, requires reboot)

### Target State (after all phases)

- **Quality Standards**: All 9 repos meet standards
- **Documentation**: 100% have CLAUDE.md
- **Testing**: All test suites passing
- **Integration**: Unified build system working
- **Automation**: Health monitoring operational
- **Community**: Engagement infrastructure in place

---

## Timeline

| Phase | Duration | Status |
|-------|----------|--------|
| Phase 0: Pre-Work | 1 session (4h) | ✅ Complete |
| Phase 1: Foundation | 1-2 sessions (8h) | 🔄 Ready to start |
| Phase 2: Repository Improvements | 1-2 weeks (parallel) | ⏸️ Pending Phase 1 |
| Phase 3: Cross-Project Integration | 1-2 weeks | ⏸️ Pending Phase 2 |
| Phase 4: Continuous Audit | Ongoing | ⏸️ Pending Phase 3 |
| **Total** | **3-4 weeks** | In progress |

---

## Philosophy

This workspace follows the Unix philosophy of the projects it manages:

- **Do one thing well**: Coordinate improvements, don't implement them
- **Work together**: Multiple parallel sessions compose together
- **Handle streams**: Track progress via git, manifest files, reports
- **Scriptable**: Everything automated via bash scripts

---

## Quick Links

- **Organization**: https://github.com/jcaldwell-labs
- **Organization Profile**: https://github.com/jcaldwell-labs/.github
- **User Registration & Contributing**: [USER-REGISTRATION.md](USER-REGISTRATION.md)
- **Current Phase**: Phase 1 - Foundation
- **Next Action**: Run `./scripts/action-dashboard.sh`

---

## For AI Agents

**Starting a new session?**

1. Read [`ROADMAP-2025.md`](ROADMAP-2025.md) to understand the overall plan
2. Check current phase in this README
3. Run `./scripts/action-dashboard.sh` to see what needs attention
4. Follow phase-specific instructions in roadmap
5. Use [`PARALLEL-SESSION-GUIDE.md`](PARALLEL-SESSION-GUIDE.md) for Phase 2 parallel work

**Claude Code specific**: See [`CLAUDE.md`](CLAUDE.md) for project-specific guidance

---

**Last Updated**: 2025-11-22
**Current Phase**: Phase 1 (Foundation)
**Status**: Phase 0 complete, ready for Phase 1
