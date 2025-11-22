# jcaldwell-labs Organization Status

**Generated**: 2025-11-20
**Last Updated**: 2025-11-20 11:58:00

## Summary

Clean, organized coordination workspace for managing 9 repositories across the jcaldwell-labs organization.

## Current State

### Open Pull Requests: 8 PRs across 6 repositories

| Repository | PR # | Title | Status | Author |
|-----------|------|-------|--------|--------|
| fintrack | #4 | Implement transaction management Phase 1 | Ready | jcaldwell1066 |
| fintrack | #3 | Write a CLAUDE.md | Ready | jcaldwell1066 |
| terminal-stars | #7 | Fix encoding issues in MODE-GUIDE.md | Draft | copilot-swe-agent |
| terminal-stars | #6 | Implement space combat mode | Ready | jcaldwell1066 |
| smartterm-prototype | #2 | Write a CLAUDE.md | Ready | jcaldwell1066 |
| my-context | #3 | Sprint 3 features and production hardening | Ready | jcaldwell1066 |
| tario | #1 | Complete platformer physics and first level | Ready | jcaldwell1066 |
| .github | #1 | Improve session persistence and skill retention | Ready | jcaldwell1066 |

**7 PRs ready for review** (1 draft)

### Local Repository Status

**Cloned locally (4/9)**:
- ✓ fintrack
- ✓ boxes-live (behind remote by 5 commits)
- ✓ adventure-engine-v2 (behind remote by 1 commit)
- ✓ smartterm-prototype

**Not cloned (5/9)**:
- terminal-stars
- atari-style
- my-context
- tario
- .github

**Action Required**: Pull latest changes for boxes-live and adventure-engine-v2

### Organization Health

| Metric | Value |
|--------|-------|
| Total Repositories | 9 |
| Primary Languages | C (5), Go (2), Python (1), Shell (1) |
| Open PRs | 8 (7 ready, 1 draft) |
| Stars | TBD (check with gh api) |
| Active Development | Last 48 hours across all projects |

## Available Scripts

All scripts are located in `./scripts/` and are executable:

### 1. Action Dashboard (`./scripts/action-dashboard.sh`)

**Purpose**: Comprehensive overview of what needs attention

**Shows**:
- Open PRs requiring review/merge
- Local repositories with uncommitted changes or sync issues
- Suggested actions categorized by work type (manual, local Claude, remote Claude)
- Quick reference commands

**When to use**: Start of every work session to identify priorities

### 2. PR Monitor (`./scripts/check-prs.sh`)

**Purpose**: Check all open PRs across organization

**Shows**:
- PR number, title, author, update time, draft status
- Total count of open PRs

**When to use**: Quick PR status check

### 3. Repository Health Check (`./scripts/repo-health.sh`)

**Purpose**: Verify local and remote repository status

**Shows**:
- Which repos are cloned locally
- Git working directory status (clean vs uncommitted changes)
- Sync status with remote (up to date, behind, ahead)
- Remote metadata (language, stars, last update)

**When to use**: Before starting local development work

## Workspace Structure

```
jcaldwell-labs/
├── archive/                    # Historical session files
│   └── 2025-11-18/            # Nov 18 cleanup - dashboards, prompts, sessions
├── repos/                      # Local clones of organization repos
│   ├── adventure-engine-v2/
│   ├── boxes-live/
│   ├── fintrack/
│   └── smartterm-prototype/
├── scripts/                    # Organization management scripts
│   ├── action-dashboard.sh    # Comprehensive action dashboard
│   ├── check-prs.sh           # PR monitoring
│   └── repo-health.sh         # Repository health checks
├── .claude/                    # Claude Code configuration
├── CLAUDE.md                   # AI agent instructions
├── README.md                   # Getting started guide
└── ORGANIZATION-STATUS.md      # This file
```

## Quick Commands

### Daily Workflow

```bash
# 1. Check what needs attention
./scripts/action-dashboard.sh

# 2. Review specific PR
cd repos/<repo-name>
gh pr checkout <pr-number>
# Review, test, comment

# 3. Merge approved PRs (on GitHub web interface)
# Or from CLI:
gh pr review <pr-number> --approve
gh pr merge <pr-number>

# 4. Sync local repos
cd repos/boxes-live
git pull origin main

cd repos/adventure-engine-v2
git pull origin main
```

### Clone Missing Repositories

```bash
# Clone individual repo
gh repo clone jcaldwell-labs/terminal-stars repos/terminal-stars

# Clone all missing repos
for repo in terminal-stars atari-style my-context tario .github; do
  gh repo clone jcaldwell-labs/$repo repos/$repo
done
```

### Context Tracking

```bash
# Start coordination session
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "org-maintenance-$(date +%Y-%m-%d)"

# Document decisions
my-context note "Merged fintrack PR #3 - adds CLAUDE.md"

# Export session
my-context export > session-summary.md
```

## Immediate Actions Required

### High Priority
1. **Review and merge 7 open PRs** - Most are ready for merge
2. **Pull latest changes** for boxes-live (5 commits behind) and adventure-engine-v2 (1 commit behind)

### Medium Priority
3. **Clone missing repos** - 5 repos not available locally (terminal-stars, atari-style, my-context, tario, .github)
4. **Review PR #7 (terminal-stars)** - Draft PR from copilot-swe-agent needs review

### Low Priority
5. **Update ORGANIZATION-STATUS.md** after merging PRs
6. **Run periodic health checks** using scripts

## Work Distribution

### Manual Actions (GitHub Web Interface)
- Merge approved PRs
- Close resolved issues
- Update repository descriptions
- Manage organization settings

### Local Claude Actions (This Session)
- Code reviews for open PRs
- Fix uncommitted changes in repos
- Write tests or documentation
- Small refactoring
- Answer questions about code

### Remote Claude Actions (github.com/claude-code)
- Implement new features from scratch
- Large-scale refactoring
- Multi-repository changes
- Complex migrations

## Links

- **Organization**: https://github.com/jcaldwell-labs
- **Profile README**: https://github.com/jcaldwell-labs/.github
- **Action Dashboard**: `./scripts/action-dashboard.sh`

---

**Next Review**: Run `./scripts/action-dashboard.sh` at start of next session
