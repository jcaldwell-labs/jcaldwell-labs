# jcaldwell-labs Workspace Setup

**Created**: 2025-11-18
**Purpose**: Clean workspace for managing all jcaldwell-labs repository PRs

## Directory Structure

```
~/projects/jcaldwell-labs/
├── repos/                              # Fresh clones of all repositories
│   ├── fintrack/
│   ├── adventure-engine-v2/
│   ├── smartterm-prototype/
│   └── boxes-live/
├── .claude/                            # Shared Claude configuration
│   ├── CLAUDE.md                      # Standard project instructions
│   └── commands/                      # Shared slash commands
└── WORKSPACE-SETUP.md                 # This file
```

## Setup Instructions

### 1. Clone All Repositories (SSH)

```bash
cd ~/projects/jcaldwell-labs/repos

# Clone all repositories
git clone git@github.com:jcaldwell-labs/fintrack.git
git clone git@github.com:jcaldwell-labs/adventure-engine-v2.git
git clone git@github.com:jcaldwell-labs/smartterm-prototype.git
git clone git@github.com:jcaldwell-labs/boxes-live.git
```

### 2. Set Up Consistent Configuration

Each repository should have:
- `.claude/CLAUDE.md` with project-specific instructions
- Consistent git configuration
- Proper .gitignore files

### 3. PR Status (from PR-REVIEW-SUMMARY-2025-11-18.md)

#### fintrack PR #4 - Transaction Management Phase 1
- **Status**: ❌ FAILING CI (4 checks)
- **Branch**: `claude/transaction-management-phase-1-018jGbVyGFV6u6AyHt4s2g2R`
- **Fixes Applied**: ✅ All fixes committed locally at `/home/be-dev-agent/projects/fintrack`
  - Fixed composite unique index on Account model
  - Fixed test reliability (all 31 tests passing)
  - Fixed gosec security issue
  - Code formatted with go fmt
- **Commit**: `c277ced` - Ready to push when connectivity restored
- **Next**: Push and verify CI passes

#### adventure-engine-v2 PR #1 - World Files & Save/Load
- **Status**: ✅ READY TO MERGE
- **Branch**: `claude/world-files-save-load-01MuSPHpArrCcztoqrSXBon8`
- **Action**: Merge and tag as v2.0.0

#### smartterm-prototype PR #3 - Extract SmartTerm Library
- **Status**: ✅ READY TO MERGE
- **Branch**: `claude/extract-smartterm-library-01KAQVpufNL6bGroqgJieTHk`
- **Action**: Merge and tag as v1.0.0

#### boxes-live PR #9 - Connector Integration Testing
- **Status**: ⚠️ NEEDS FIXES
- **Branch**: `claude/connector-integration-testing-01J73aAxTSyw3EuCZzZ8m3c4`
- **Issues**: Copilot found bugs in test scripts and documentation
- **Action**: Fix bugs, test, then merge

## Workflow for Each PR

### Standard PR Review Process

1. **Navigate to repo**
   ```bash
   cd ~/projects/jcaldwell-labs/repos/<repo-name>
   ```

2. **Checkout PR branch**
   ```bash
   gh pr checkout <pr-number>
   # or
   git fetch origin && git checkout <branch-name>
   ```

3. **Run local checks**
   ```bash
   # For Go projects (fintrack)
   go fmt ./...
   go vet ./...
   go test -v -race ./...
   gosec ./...
   go build ./cmd/...

   # For C projects (adventure-engine-v2, smartterm-prototype)
   make clean
   make
   make test  # if available

   # For bash projects (boxes-live)
   shellcheck **/*.sh
   ./tests/connector_integration_test.sh
   ```

4. **Fix any issues**
   - Address linter errors
   - Fix failing tests
   - Resolve security issues
   - Update documentation

5. **Commit and push**
   ```bash
   git add -A
   git commit -m "fix: description of fixes"
   git push origin <branch-name>
   ```

6. **Verify CI passes**
   ```bash
   gh pr checks <pr-number>
   ```

7. **Merge when green**
   ```bash
   gh pr merge <pr-number> --squash
   ```

## Current Status

### Completed Work (fintrack)

All fixes for fintrack PR #4 are completed and committed locally at:
- **Location**: `/home/be-dev-agent/projects/fintrack`
- **Branch**: `claude/transaction-management-phase-1-018jGbVyGFV6u6AyHt4s2g2R`
- **Commit**: `c277ced`

**Fixes Applied**:
1. ✅ Fixed composite unique index: `(name, is_active)` on Account model
2. ✅ Fixed test reliability: All 31 tests passing
3. ✅ Fixed gosec security issue: Unhandled error in account.go
4. ✅ Code formatting: All files formatted with go fmt

**Pending**: Push to GitHub when connectivity restored

### Next Steps

1. ⏳ **Wait for GitHub connectivity** - Currently getting 502/connection errors
2. 🔄 **Clone fresh repos** when GitHub is accessible
3. 🔧 **Apply fintrack fixes** from existing working directory
4. ✅ **Merge ready PRs** (adventure-engine-v2, smartterm-prototype)
5. 🐛 **Fix boxes-live bugs** per Copilot review
6. 🎉 **Complete all PRs** and update coordination workspace

## GitHub Connectivity Issues

**Observed**: 2025-11-18 ~16:00 UTC
- HTTPS: `502 Bad Gateway` errors
- SSH: Connection timeouts/refusals
- Status: Investigating

**Workaround**: All work completed locally, ready to push when GitHub recovers.

## Tools & Dependencies

### Required Tools
- `gh` - GitHub CLI for PR management
- `golangci-lint` - Go linting (fintrack)
- `gosec` - Go security scanner (fintrack)
- `shellcheck` - Bash linting (boxes-live)

### Installation
```bash
# GitHub CLI
# Already installed

# golangci-lint
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# gosec
go install github.com/securego/gosec/v2/cmd/gosec@latest

# shellcheck
sudo apt-get install shellcheck  # Debian/Ubuntu
```

## Related Documentation

- **PR Review Summary**: `~/projects/jcaldwell-labs/PR-REVIEW-SUMMARY-2025-11-18.md`
- **Fintrack Fixes**: See commit `c277ced` in `/home/be-dev-agent/projects/fintrack`

---

**Last Updated**: 2025-11-18
**Maintained By**: Claude Code Agent
