# jcaldwell-labs Organization Hub

Central coordination workspace for the [jcaldwell-labs](https://github.com/jcaldwell-labs) GitHub organization.

## Purpose

This workspace provides:
- **Quick health checks** for all organization repositories
- **PR monitoring** across all projects
- **Action dashboards** for local, local-claude, and remote-claude work
- **Central documentation** for organization-level processes

This is NOT a code repository - it's a coordination hub for managing multiple terminal-based open source projects.

## Quick Start

### Check what needs attention right now

```bash
./scripts/action-dashboard.sh
```

This shows:
- Open PRs requiring review
- Local repos with uncommitted changes or sync issues
- Suggested actions (manual, local Claude, or remote Claude)
- Quick commands for common tasks

### Monitor open PRs

```bash
./scripts/check-prs.sh
```

### Check repository health

```bash
./scripts/repo-health.sh
```

## Directory Structure

```
jcaldwell-labs/
├── scripts/              # Health monitoring and dashboard scripts
│   ├── action-dashboard.sh
│   ├── check-prs.sh
│   └── repo-health.sh
├── repos/                # Local clones of organization repositories
│   ├── fintrack/
│   ├── boxes-live/
│   ├── adventure-engine-v2/
│   └── ...
├── archive/              # Archived session files and old documentation
│   └── 2025-11-18/
├── CLAUDE.md            # Instructions for Claude Code
└── README.md            # This file
```

## Organization Projects

| Repository | Language | Status | Description |
|-----------|----------|--------|-------------|
| [fintrack](https://github.com/jcaldwell-labs/fintrack) | Go | Active | Financial tracking and analysis |
| [terminal-stars](https://github.com/jcaldwell-labs/terminal-stars) | C | Active | Starfield visualization |
| [adventure-engine-v2](https://github.com/jcaldwell-labs/adventure-engine-v2) | C | Active | Text adventure engine |
| [boxes-live](https://github.com/jcaldwell-labs/boxes-live) | Shell | Active | Terminal canvas (Miro alternative) |
| [smartterm-prototype](https://github.com/jcaldwell-labs/smartterm-prototype) | C | Active | Terminal UI library |
| [atari-style](https://github.com/jcaldwell-labs/atari-style) | Python | Active | Atari-style game framework |
| [my-context](https://github.com/jcaldwell-labs/my-context) | Go | Production | Agent journal and context management |
| [tario](https://github.com/jcaldwell-labs/tario) | C | Active | ASCII platformer game |
| [.github](https://github.com/jcaldwell-labs/.github) | Markdown | Active | Organization profile |

## Current Open PRs (as of 2025-11-20)

Run `./scripts/check-prs.sh` for current status.

Recent snapshot shows PRs in:
- **fintrack**: PRs #4 (transaction management), #3 (CLAUDE.md)
- **terminal-stars**: PRs #7 (encoding fix), #6 (space combat mode)
- **smartterm-prototype**: PR #2 (CLAUDE.md)
- **my-context**: PR #3 (Sprint 3 features)
- **tario**: PR #1 (platformer physics)
- **.github**: PR #1 (session persistence)

## Common Workflows

### Clone a repository for local work

```bash
gh repo clone jcaldwell-labs/<repo-name> repos/<repo-name>
cd repos/<repo-name>
```

### Review a PR locally

```bash
cd repos/<repo-name>
gh pr checkout <pr-number>
# Make changes, run tests, etc.
gh pr review --approve  # or --comment or --request-changes
```

### Check all local repos for issues

```bash
./scripts/repo-health.sh
```

### Identify next actions

```bash
./scripts/action-dashboard.sh
```

## Work Categories

### 🖥️ Manual Actions (local terminal)
- Merge approved PRs on GitHub
- Create releases
- Manage organization settings
- Update repository descriptions

### 🤖 Claude Local Actions (this session)
- Code reviews for open PRs
- Fix issues in cloned repos
- Write tests or documentation
- Small refactoring tasks
- Answer questions about code

### ☁️ Claude Remote Actions (github.com/claude-code)
- Create new features from scratch
- Large refactoring projects
- Multi-file changes across repositories
- Complex migrations

## Context Tracking

All coordination work uses my-context database mode:

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "task-$(date +%Y-%m-%d)"
my-context note "your note here"
my-context export > summary.md
```

Project-specific work should use project-specific partitions:
- `db:fintrack_dev`
- `db:boxes_live_dev`
- etc.

## Philosophy

All projects follow Unix philosophy:
- Do one thing well
- Work together via composition
- Terminal-first (no GUI dependencies)
- SSH-friendly (works over remote connections)

## Links

- **Organization**: https://github.com/jcaldwell-labs
- **Profile README**: https://github.com/jcaldwell-labs/.github
- **CLAUDE.md**: Instructions for Claude Code sessions

---

**Last Updated**: 2025-11-20
**Maintained By**: @jcaldwell1066
