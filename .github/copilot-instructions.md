# GitHub Copilot Instructions

This file provides guidance to GitHub Copilot when working with this coordination workspace.

## Project Overview

This is the **coordination workspace** for the [jcaldwell-labs](https://github.com/jcaldwell-labs) GitHub organization. Unlike other repositories in this org, this is NOT a code project - it's a management and planning hub for 9 terminal-based open source projects.

**Status**: Active coordination hub
**Type**: Meta-repository (coordination, not code)
**Projects Managed**: 9 (5 C, 2 Go, 1 Python, 1 Markdown)

Key capabilities:
- Cross-project health monitoring and status tracking
- Unified build/test system for all projects
- PR review coordination and escalation
- Session tracking and handoff documentation
- Roadmap and phase planning

## What This Workspace Does

### Coordination Tasks (Primary)
- Monitor PR status across all 9 repositories
- Generate health reports and improvement recommendations
- Track parallel work sessions and handoffs
- Maintain roadmaps and phase planning documents

### Automation Scripts
- `action-dashboard.sh` - Comprehensive status overview
- `check-prs.sh` - PR status across all repos
- `repo-health.sh` - Repository health checks
- `daily-health-check.sh` - Automated daily monitoring
- `build-c-projects.sh` / `test-c-projects.sh` - C project management
- `build-go-projects.sh` / `test-go-projects.sh` - Go project management

### NOT Code Development
This workspace does not contain application code. For code work, use the individual project repositories.

## Directory Structure

```
jcaldwell-labs/
├── .github/
│   ├── workflows/
│   │   └── daily-health-check.yml  # Automated monitoring
│   └── copilot-instructions.md     # This file
├── scripts/                         # Management automation
│   ├── action-dashboard.sh          # Start here - full status
│   ├── check-prs.sh                 # PR status check
│   ├── repo-health.sh               # Health monitoring
│   ├── build-c-projects.sh          # Build all C projects
│   ├── test-c-projects.sh           # Test all C projects
│   ├── build-go-projects.sh         # Build all Go projects
│   └── test-go-projects.sh          # Test all Go projects
├── docs/                            # Protocol documents
│   ├── PR-FAILURE-PROTOCOL.md       # When PRs fail
│   ├── ESCALATION-PROTOCOL.md       # Issue escalation
│   ├── DONE-DEFINITION.md           # Completion criteria
│   └── SESSION-HANDOFF-PROTOCOL.md  # Handoff procedures
├── prompts/                         # Session prompts for phases
├── reports/                         # Generated improvement reports
├── sessions/                        # Session handoff docs
├── templates/                       # Workflow templates
├── repos/                           # Local clones (gitignored)
├── Makefile                         # Unified build system
├── ROADMAP-2025.md                  # Complete improvement plan
├── CLAUDE.md                        # AI agent guidance
└── README.md                        # User documentation
```

## Projects Under Management

| Repository | Language | Primary Focus |
|-----------|----------|---------------|
| [fintrack](https://github.com/jcaldwell-labs/fintrack) | Go | Financial tracking CLI |
| [boxes-live](https://github.com/jcaldwell-labs/boxes-live) | C | Terminal canvas (Miro alternative) |
| [terminal-stars](https://github.com/jcaldwell-labs/terminal-stars) | C | 3D space combat simulator |
| [my-context](https://github.com/jcaldwell-labs/my-context) | Go | Context management CLI |
| [tario](https://github.com/jcaldwell-labs/tario) | C | ASCII platformer game |
| [adventure-engine-v2](https://github.com/jcaldwell-labs/adventure-engine-v2) | C | Text adventure engine |
| [smartterm-prototype](https://github.com/jcaldwell-labs/smartterm-prototype) | C | Terminal UI library |
| [atari-style](https://github.com/jcaldwell-labs/atari-style) | Python | Terminal arcade games |
| [.github](https://github.com/jcaldwell-labs/.github) | Markdown | Organization profile |

## Build System

```bash
# Show all available targets
make help

# Build all projects (C and Go)
make build-all

# Test all projects
make test-all

# Build/test by language
make build-c-all      # Build C projects only
make test-c-all       # Test C projects only
make build-go-all     # Build Go projects only
make test-go-all      # Test Go projects only
```

## Coordination Workflows

### Starting a Coordination Session

```bash
# 1. Get current status
./scripts/action-dashboard.sh

# 2. Start context tracking (recommended)
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "coordination-$(date +%Y-%m-%d)"

# 3. Check specific areas
./scripts/check-prs.sh      # PR status
./scripts/repo-health.sh    # Health check
```

### Checking PR Status Across All Repos

```bash
# Quick check
./scripts/check-prs.sh

# Or manually
for repo in fintrack boxes-live terminal-stars my-context tario adventure-engine-v2 smartterm-prototype atari-style; do
  echo "=== $repo ==="
  gh pr list --repo jcaldwell-labs/$repo --state open
done
```

### Building and Testing All Projects

```bash
# Full build and test
make build-all && make test-all

# Or use scripts directly
./scripts/build-c-projects.sh
./scripts/test-c-projects.sh
./scripts/build-go-projects.sh
./scripts/test-go-projects.sh
```

### Creating GitHub Issues Across Repos

```bash
# Create issue in specific repo
gh issue create --repo jcaldwell-labs/<repo-name> \
  --title "Issue title" \
  --body "Issue description"

# List issues
gh issue list --repo jcaldwell-labs/<repo-name>
```

## Delegatable Coordination Tasks

The following tasks can be assigned to Copilot coding agents:

### Health and Status Tasks
- Run `./scripts/action-dashboard.sh` and summarize findings
- Check for stale PRs (open > 7 days) across all repos
- Verify all repos have required files (CLAUDE.md, copilot-instructions.md)
- Generate cross-project dependency report

### PR Management Tasks
- Review PR descriptions for completeness
- Check PR CI status across repos
- Identify PRs ready to merge
- Flag PRs with conflicts

### Documentation Tasks
- Update ORGANIZATION-STATUS.md with current state
- Generate weekly health summary
- Audit README.md files across all repos
- Cross-reference documentation consistency

### Planning Tasks (Future)
- Analyze GitHub issues across repos for patterns
- Suggest priority ordering for open issues
- Identify cross-project dependencies
- Generate phase completion reports

## Before Committing (Required Steps)

This workspace primarily contains documentation and scripts. Before committing:

1. **Validate scripts**: Ensure any script changes are syntactically correct
   ```bash
   bash -n scripts/<script-name>.sh
   ```

2. **Test Makefile**: Verify make targets work
   ```bash
   make help
   ```

3. **Check documentation**: Ensure markdown renders correctly

4. **Verify links**: Check that cross-references are valid

```bash
# Quick validation
bash -n scripts/*.sh && make help
```

## Common Coordination Tasks

### Audit Organization Health

1. Run status check: `./scripts/action-dashboard.sh`
2. Review output for issues
3. Document findings in my-context
4. Create issues in affected repos if needed

### Coordinate Parallel Sessions

1. Check PARALLEL-SESSION-MANIFEST.md for active sessions
2. Review session handoff docs in sessions/
3. Update manifest with new session info
4. Communicate via my-context exports

### Phase Transition

1. Verify current phase completion (VALIDATION-CHECKLIST.md)
2. Generate phase summary report
3. Update ROADMAP-2025.md status
4. Prepare next phase prompts

### Create Improvement Report

1. Use template: `templates/IMPROVEMENT-REPORT-TEMPLATE.md`
2. Fill in all sections with findings
3. Save to `reports/<repo>-improvement-report.md`
4. Link from ORGANIZATION-STATUS.md

## Pull Request Standards

When creating PRs for this workspace:

**Required PR format:**
```markdown
## Summary
[2-3 sentences describing what coordination improvement this PR provides]

## Changes
- [Actual change 1]
- [Actual change 2]

## Validation
- [ ] Scripts tested (`bash -n scripts/*.sh`)
- [ ] Makefile works (`make help`)
- [ ] Documentation accurate

## Type
- [ ] Documentation | Script | Workflow | Template | Planning
```

## Context Tracking

All coordination work should be tracked in my-context:

```bash
# Start session
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "coordination-$(date +%Y-%m-%d)"

# Track findings
my-context note "Finding: 3 repos have stale PRs"
my-context note "Decision: Prioritize boxes-live PR review"

# Export summary
my-context export > sessions/$(date +%Y-%m-%d)-summary.md
```

## CI/CD Pipeline

GitHub Actions workflow (`.github/workflows/daily-health-check.yml`):
- Triggers: Daily scheduled run, manual dispatch
- Actions: Checks PR status, repo health, generates reports
- Outputs: Status badges, health report artifacts

## Key Documents

- **ROADMAP-2025.md** - Complete 4-phase improvement plan
- **CLAUDE.md** - AI agent guidance (detailed)
- **PARALLEL-SESSION-GUIDE.md** - Multi-session coordination
- **VALIDATION-CHECKLIST.md** - Phase completion criteria
- **ORGANIZATION-STATUS.md** - Current state snapshot

## Philosophy

This workspace follows Unix philosophy:
- **Do one thing well**: Coordinate improvements, don't implement them
- **Work together**: Multiple parallel sessions compose together
- **Handle streams**: Track progress via git, manifest files, reports
- **Scriptable**: Everything automated via bash scripts

## Future Capabilities

This workspace is designed to support increasing levels of autonomous coordination:

1. **Current**: Health monitoring, PR tracking, report generation
2. **Near-term**: Priority suggestions, dependency analysis, conflict detection
3. **Future**: Autonomous issue triage, cross-project planning, resource allocation

As GitHub Copilot capabilities expand, this workspace will serve as the coordination layer for delegating increasingly complex planning and prioritization tasks.
