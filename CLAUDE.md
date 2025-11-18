# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **coordination workspace** for the [jcaldwell-labs](https://github.com/jcaldwell-labs) GitHub organization, not a code repository itself. It serves as a central planning and tracking hub for managing multiple terminal-based open source projects.

## Purpose

The jcaldwell-labs organization develops Unix philosophy-inspired terminal tools that compete with modern enterprise suites using only terminal-based interfaces:

| Enterprise Tool | Terminal Alternative | Status |
|----------------|---------------------|--------|
| Miro | boxes-live | Active development |
| Jira | my-context | Production ready |
| Web browsers | tmux-based workflows | Concept |
| X-Ray/tracing | Active document realm | Planning |

Additional projects include educational games, animations, and terminal utilities.

## Organization Strategy

### Multi-Agent Coordination

**Objective:** Maximize remote Claude Code session productivity while minimizing local terminal work.

**Approach:**
1. Each project should have clear next steps for autonomous agent sessions
2. Features should be identified that can be developed in parallel across projects
3. Active PRs should be reviewed and progressed regularly
4. All work should be tracked in `my-context` database partitions

### Context Management

**Database Partition:** `db:jcaldwell_labs`

All coordination work for this organization should be tracked in the dedicated my-context partition:

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "audit-2025-11-18"
my-context note "your finding or decision here"
```

## Current Projects (as of 2025-11-18)

### Active Development
1. **terminal-stars** (C) - Starfield visualization with frame buffering
2. **tario** (C) - ASCII side-scrolling platformer game
3. **adventure-engine-v2** (C) - Text adventure engine with smart terminal UI
4. **fintrack** (Go) - Financial tracking and analysis tool
5. **boxes-live** (C) - Terminal-based interactive canvas (Miro alternative)
6. **smartterm-prototype** (C) - Terminal UI library proof-of-concept

### Production Tools
7. **my-context** (Go) - Agent journal and context management CLI
8. **.github** - Organization profile and community health files

## Common Commands

### Repository Management

```bash
# List all organization repositories
gh repo list jcaldwell-labs --limit 100

# Check for open PRs across all projects
for repo in terminal-stars tario adventure-engine-v2 fintrack boxes-live smartterm-prototype my-context; do
  echo "=== $repo ==="
  gh pr list --repo jcaldwell-labs/$repo --state open
done

# Clone a project for development
gh repo clone jcaldwell-labs/<project-name>
cd <project-name>
```

### Context Tracking

```bash
# Start coordination session
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "project-audit-$(date +%Y-%m-%d)"

# Document decisions
my-context note "Decision: Focus on boxes-live as flagship project"

# Track related files
my-context file ~/projects/jcaldwell-labs/README.md

# Export session summary
my-context export "project-audit-2025-11-18" > audit-summary.md
```

### Project-Specific Work

When working on individual projects, use project-specific context partitions:

```bash
# For my-context project work
export MY_CONTEXT_HOME=db:my_context_dev

# For fintrack work
export MY_CONTEXT_HOME=db:fintrack_dev

# For boxes-live work
export MY_CONTEXT_HOME=db:boxes_live_dev
```

## Architecture Principles

### Unix Philosophy
All projects follow Unix philosophy:
- Do one thing well
- Work together via composition
- Handle text/data streams
- Provide scriptable interfaces

### Terminal-First
- No GUI dependencies
- ncurses or ANSI escape codes for visualization
- SSH-friendly (works over remote connections)
- Works in tmux/screen

### Agent-Friendly Development
- Clear documentation for autonomous agents
- Comprehensive test coverage
- Well-structured commit history
- Active documentation that doubles as validation

## Workflow Guidelines

### Starting New Work

1. **Check existing work first:**
   ```bash
   MY_CONTEXT_HOME=db:jcaldwell_labs my-context list --search "<topic>"
   ```

2. **Review recent activity:**
   ```bash
   cd ~/projects
   ls -lt | head -10  # See recent project work
   ```

3. **Check for open PRs:**
   ```bash
   gh pr list --repo jcaldwell-labs/<project> --state open
   ```

4. **Start tracked session:**
   ```bash
   MY_CONTEXT_HOME=db:jcaldwell_labs my-context start "<task>-$(date +%Y-%m-%d)"
   ```

### Completing Work

1. **Document decisions and findings:**
   ```bash
   my-context note "Finding: <what you discovered>"
   my-context note "Decision: <what was decided and why>"
   ```

2. **Export session summary:**
   ```bash
   my-context export --to ~/projects/$(date +%Y-%m-%d)-<task>.md
   ```

3. **Stop context:**
   ```bash
   my-context stop
   ```

### Parallel Work Coordination

To maximize agent productivity:

1. **Identify parallelizable features** across projects
2. **Create clear specifications** for each feature
3. **Launch multiple agent sessions** (one per feature)
4. **Track progress** in my-context database
5. **Review and integrate** completed work

## Key Files in This Workspace

- `README.md` - Strategic vision and current objectives (maintained by owner)
- `CLAUDE.md` - This file - guidance for AI agents
- `db:jcaldwell_labs/` - my-context partition for coordination work (database backend)

## Project Health Metrics

### As of 2025-11-18

| Metric | Value |
|--------|-------|
| Total Projects | 8 |
| Primary Languages | C (5), Go (2), Markdown (1) |
| Open PRs | 0 |
| Total Stars | 0 (newly launched org) |
| Active Development | All projects updated within 48 hours |

### Recent Accomplishments

- ✅ Organization launched November 2025
- ✅ 4 initial projects migrated from personal account
- ✅ Security audit completed (no sensitive data)
- ✅ Comprehensive READMEs for all projects
- ✅ Database-backed my-context system operational
- ✅ Active development across all projects

## Navigation

### To Work on Specific Projects

Each project has its own repository with its own CLAUDE.md (or should have):

```bash
# Clone and work on a specific project
cd ~/projects
gh repo clone jcaldwell-labs/<project-name>
cd <project-name>

# Read project-specific guidance
cat CLAUDE.md  # If it exists

# Use project-specific context partition
export MY_CONTEXT_HOME=db:<project-name>_dev
```

### To Coordinate Across Projects

Stay in this workspace and use the jcaldwell_labs partition:

```bash
cd ~/projects/jcaldwell-labs
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "cross-project-<task>"
```

## Skills Available

Reference the global Claude Code skills in `~/.claude/skills/` for specialized workflows:

- **my-context-workflow** - Context tracking and session management
- **git-worktree** - Multi-branch development patterns
- **paymentservice-pr-review** - PR review patterns (adapt for open source)

## Notes for Future AI Sessions

When resuming work in this coordination workspace:

1. **Always check README.md first** - Contains latest strategic priorities
2. **Review recent my-context sessions** - See what was done recently
3. **Check for new PRs** - Across all organization projects
4. **Audit project health** - Stars, issues, recent commits
5. **Look for parallel opportunities** - Features that can be developed simultaneously

## Quick Reference Links

- Organization: https://github.com/jcaldwell-labs
- Profile README: https://github.com/jcaldwell-labs/.github
- my-context: https://github.com/jcaldwell-labs/my-context
- boxes-live: https://github.com/jcaldwell-labs/boxes-live
- fintrack: https://github.com/jcaldwell-labs/fintrack
- terminal-stars: https://github.com/jcaldwell-labs/terminal-stars
