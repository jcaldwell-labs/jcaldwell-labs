# JCaldwell Labs - Coordination Workspace

**Organization:** https://github.com/jcaldwell-labs
**Purpose:** Central coordination hub for managing Unix philosophy-inspired terminal tools

---

## Quick Links

- 📊 **[DASHBOARD.md](./DASHBOARD.md)** - Current status of all projects, open PRs, and next actions
- 📋 **[NEXT-STEPS.md](./NEXT-STEPS.md)** - Detailed follow-up prompts and parallel work opportunities
- 📖 **[CLAUDE.md](./CLAUDE.md)** - Guidance for AI agents working in this workspace

---

## Projects Overview

| Project | Description | Status |
|---------|-------------|--------|
| **[my-context](https://github.com/jcaldwell-labs/my-context)** | Agent journal CLI (like Jira for terminal) | Production |
| **[boxes-live](https://github.com/jcaldwell-labs/boxes-live)** | Interactive canvas (like Miro for terminal) | MVP Complete |
| **[fintrack](https://github.com/jcaldwell-labs/fintrack)** | Financial tracking and analysis | Phase 1 MVP |
| **[terminal-stars](https://github.com/jcaldwell-labs/terminal-stars)** | Starfield visualization and games | Active Dev |
| **[tario](https://github.com/jcaldwell-labs/tario)** | ASCII side-scrolling platformer | Active Dev |
| **[adventure-engine-v2](https://github.com/jcaldwell-labs/adventure-engine-v2)** | Text adventure engine | DSL Design |
| **[smartterm-prototype](https://github.com/jcaldwell-labs/smartterm-prototype)** | Terminal UI library POC | Decision Point |

---

## Current Status (2025-11-18)

### Open PRs Requiring Review: 4

1. **terminal-stars PR #5** - Skeet shooting game mode
2. **fintrack PR #3** - CLAUDE.md documentation
3. **smartterm-prototype PR #2** - CLAUDE.md documentation
4. **.github PR #1** - Session persistence improvements

**See [DASHBOARD.md](./DASHBOARD.md) for detailed PR information and review instructions.**

---

## Vision

Build a suite of Unix philosophy terminal tools that compete with modern enterprise software:

| Enterprise Tool | Terminal Alternative | Progress |
|----------------|---------------------|----------|
| Miro | boxes-live | MVP ✓ |
| Jira | my-context | Production ✓ |
| Excel | fintrack | Phase 1 |
| Arcade Games | tario, terminal-stars | Active |
| Interactive Fiction | adventure-engine-v2 | Design |

**Philosophy:**
- Do one thing well
- Work together via composition
- Handle text/data streams
- Provide scriptable interfaces
- SSH-friendly (no GUI dependencies)

---

## Getting Started

### For AI Agents

Start a coordination session:
```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "task-$(date +%Y-%m-%d)"
```

Read the guidance:
```bash
cat CLAUDE.md      # Agent guidance
cat DASHBOARD.md   # Current status
cat NEXT-STEPS.md  # Available work
```

### For Developers

Check project health:
```bash
# See all open PRs
/tmp/check-prs.sh

# Clone a project
gh repo clone jcaldwell-labs/<project-name>

# Work on a project with context tracking
export MY_CONTEXT_HOME=db:<project>_dev
my-context start "feature-<name>"
```

---

## Coordination Strategy

### Multi-Agent Approach

**Objective:** Maximize parallel development across projects while maintaining quality

**Method:**
1. Identify features that can be developed independently ✓ (see NEXT-STEPS.md)
2. Create clear specifications and prompts for each ✓ (18+ prompts ready)
3. Launch multiple autonomous agent sessions in parallel
4. Track all work in my-context database partitions ✓ (db:jcaldwell_labs + project-specific)
5. Review and integrate completed work

**Current Focus:**
- High-value features (my-context queries, boxes-live persistence, fintrack transactions)
- Documentation completion (CLAUDE.md for all projects)
- PR reviews (4 pending)

---

## Active Work Sessions

Track coordination work in the dedicated partition:

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs

# List recent coordination sessions
my-context list --search "jcaldwell"

# View current audit session
my-context show jcaldwell-labs-audit-2025-11-18
```

Track project-specific work in project partitions:

```bash
# Examples
export MY_CONTEXT_HOME=db:fintrack_dev
export MY_CONTEXT_HOME=db:boxes_live_dev
export MY_CONTEXT_HOME=db:terminal_stars_dev
```

---

## Next Actions

### Priority 1 (Today)
1. Review and merge 4 open PRs (see DASHBOARD.md)
2. Implement fintrack transaction management
3. Add boxes-live canvas persistence

### Priority 2 (This Week)
4. Complete CLAUDE.md for all 8 projects
5. Implement my-context advanced queries
6. Add tario enemy AI
7. Design adventure-engine DSL

### Priority 3 (This Month)
8. Launch parallel agent sessions for 6+ features
9. Achieve 10+ GitHub stars across projects
10. Complete comprehensive test coverage

**See [NEXT-STEPS.md](./NEXT-STEPS.md) for detailed prompts and implementation guidance.**

---

## Files in This Workspace

| File | Purpose |
|------|---------|
| `README.md` | This file - quick reference and strategic overview |
| `DASHBOARD.md` | Live status dashboard - projects, PRs, health metrics |
| `NEXT-STEPS.md` | Detailed work opportunities with ready-to-use prompts |
| `CLAUDE.md` | Comprehensive AI agent guidance for coordination |
| `db:jcaldwell_labs/` | my-context database partition for coordination sessions |

---

## Resources

- **Organization:** https://github.com/jcaldwell-labs
- **Skills:** `~/.claude/skills/my-context-workflow` (context management patterns)
- **Support:** Create issues in individual project repositories

---

**Last Updated:** 2025-11-18 by jcaldwell-labs-audit session
**Next Review:** Daily (automated dashboard updates planned)
