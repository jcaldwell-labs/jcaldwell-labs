# Parallel Session Coordination Guide

**Version**: 1.0
**Date**: 2025-11-22
**Purpose**: Coordinate multiple Claude Code sessions working on jcaldwell-labs repositories

---

## Overview

This guide enables launching 5-7 parallel Claude Code sessions to improve all jcaldwell-labs repositories simultaneously, reducing Phase 2 timeline from 4-6 weeks (sequential) to 1-2 weeks (parallel).

**Key Principle**: Each session works independently on assigned repository using standard checklist, then reports results for rollup validation.

---

## Prerequisites

Before launching parallel sessions:

- [ ] Phase 1 complete (all PRs merged, repos synced)
- [ ] All repositories cloned to `~/projects/jcaldwell-labs/repos/`
- [ ] This guide committed to repository
- [ ] `PARALLEL-SESSION-MANIFEST.md` created and committed
- [ ] Improvement report template created

---

## Session Assignments

### Recommended Configuration (7 sessions)

| Session | Repository | Complexity | Est. Duration | Notes |
|---------|-----------|------------|---------------|-------|
| Session A | fintrack | High | 6-8 hours | Go, database, CLI |
| Session B | boxes-live | High | 6-8 hours | C, ncurses, networking |
| Session C | terminal-stars | Medium | 4-6 hours | C, graphics, modes |
| Session D | my-context | High | 6-8 hours | Go, PostgreSQL, critical tool |
| Session E | tario | Medium | 4-6 hours | C, game engine, physics |
| Session F | adventure-engine-v2 | Medium | 4-6 hours | C, parser, UI |
| Session G | smartterm-prototype | Low | 3-4 hours | C, library extraction |
| Session G | atari-style | Medium | 4-6 hours | **CRITICAL**: USB fix required |
| Session G | .github | Low | 2-3 hours | Organization docs |

**Note**: Session G handles 3 smaller/lower-complexity repos sequentially within one session.

### Alternative Configuration (5 sessions)

Combine smaller repos:
- Session A: fintrack
- Session B: boxes-live
- Session C: terminal-stars + tario
- Session D: my-context
- Session E: adventure-engine-v2 + smartterm-prototype + atari-style + .github

---

## Session Launch Procedure

### 1. Coordinator Preparation (Local Session)

```bash
# 1.1 Ensure Phase 1 complete
cd ~/projects/jcaldwell-labs
./scripts/action-dashboard.sh  # Should show clean state

# 1.2 Create manifest file
cat > PARALLEL-SESSION-MANIFEST.md << 'EOF'
# Parallel Session Manifest

**Phase**: 2 - Repository Improvements
**Started**: $(date +%Y-%m-%d)
**Status**: In Progress

## Session Status

| Repository | Status | Session ID | Started | Completed | PR | Report | Blocker |
|-----------|--------|-----------|---------|-----------|----|----|---------|
| fintrack | not_started | - | - | - | - | - | - |
| boxes-live | not_started | - | - | - | - | - | - |
| terminal-stars | not_started | - | - | - | - | - | - |
| my-context | not_started | - | - | - | - | - | - |
| tario | not_started | - | - | - | - | - | - |
| adventure-engine-v2 | not_started | - | - | - | - | - | - |
| smartterm-prototype | not_started | - | - | - | - | - | - |
| atari-style | not_started | - | - | - | - | - | - |
| .github | not_started | - | - | - | - | - | - |

## Status Definitions
- not_started: No session claimed yet
- in_progress: Session actively working
- completed: Session finished, PR submitted
- blocked: Issue preventing completion

## Instructions for Sessions

1. Choose an unclaimed repository
2. Update this manifest (set status=in_progress, session ID, started date)
3. Commit and push manifest update
4. Complete standard checklist for your repository
5. Create PR with improvements
6. Write improvement report
7. Update manifest (set status=completed, completion date, PR link, report link)
8. Commit and push manifest update
EOF

# 1.3 Create improvement report template
mkdir -p templates
cat > templates/IMPROVEMENT-REPORT-TEMPLATE.md << 'EOF'
# [REPOSITORY] Improvement Report

**Repository**: [repository-name]
**Session ID**: [your-session-id]
**Date**: [YYYY-MM-DD]
**Duration**: [hours]

---

## Executive Summary

[1-2 paragraph summary of what was done and key findings]

---

## Checklist Completion

### Documentation
- [ ] CLAUDE.md verified/created
- [ ] README.md improved
- [ ] CONTRIBUTING.md added
- [ ] Architecture documented
- [ ] Dependencies documented
- [ ] Troubleshooting section added

### Code Quality
- [ ] Linter/formatter run
- [ ] Code comments improved
- [ ] Compiler warnings fixed
- [ ] TODOs addressed
- [ ] Security issues checked
- [ ] Dead code removed

### Testing
- [ ] Test suite verified
- [ ] Tests added for critical paths
- [ ] All tests passing
- [ ] Coverage documented
- [ ] Integration tests added
- [ ] Test documentation updated

### Build System
- [ ] Build instructions verified
- [ ] Makefile added/improved
- [ ] Build targets added
- [ ] Dependencies documented
- [ ] Clean build tested

### CI/CD
- [ ] GitHub Actions added
- [ ] CI runs tests
- [ ] Build verification added
- [ ] Linter added to CI
- [ ] CI badge added to README

### Project Health
- [ ] Open issues reviewed
- [ ] Issue templates added
- [ ] PR template added
- [ ] GitHub description updated
- [ ] License verified
- [ ] Changelog added

---

## Repository-Specific Tasks

[List tasks specific to this repository - see ROADMAP-2025.md Phase 2]

- [ ] Task 1
- [ ] Task 2
- [ ] ...

---

## What Was Done

### Changes Made
1. [Change 1 with brief description]
2. [Change 2 with brief description]
3. ...

### Files Modified
- `file1.c` - [what changed]
- `file2.go` - [what changed]
- ...

### Files Added
- `new-file.md` - [purpose]
- ...

### Tests Added
- `test_feature.c` - [what it tests]
- ...

---

## Findings

### Issues Found
1. [Issue description, severity, how addressed]
2. ...

### Security Concerns
[Any security issues found and how they were fixed]

### Technical Debt
[Technical debt identified but not addressed - for future work]

---

## Metrics

### Before
- Test coverage: [X%]
- Compiler warnings: [N]
- Open issues: [N]
- Documentation completeness: [X%]
- Lines of code: [N]

### After
- Test coverage: [X%] (+/- Y%)
- Compiler warnings: [N] (+/- Y)
- Open issues: [N] (+/- Y)
- Documentation completeness: [X%] (+/- Y%)
- Lines of code: [N] (+/- Y)

---

## Pull Requests

- PR #[N]: [Title] - [URL]
  - [Brief description]
  - Status: [Draft/Ready/Merged]

---

## Blockers and Dependencies

[Any issues that prevented completion or require follow-up]

- Blocker 1: [description and proposed resolution]
- ...

---

## Recommendations

### Immediate Actions
1. [Action item 1]
2. ...

### Future Improvements
1. [Improvement 1]
2. ...

---

## Session Export

my-context session: [link or filename]

---

## Sign-off

- [ ] All checklist items completed or documented as N/A
- [ ] All tests passing
- [ ] PR created and ready for review
- [ ] Documentation updated
- [ ] No critical blockers

**Completed by**: [Session ID]
**Date**: [YYYY-MM-DD]
EOF

# 1.4 Commit baseline
git add .
git commit -m "Add parallel session coordination framework

- ROADMAP-2025.md: Complete 4-phase improvement plan
- PARALLEL-SESSION-GUIDE.md: Session coordination instructions
- PARALLEL-SESSION-MANIFEST.md: Session tracking manifest
- templates/IMPROVEMENT-REPORT-TEMPLATE.md: Standard reporting

Ready to launch Phase 2 parallel sessions."

git push origin master
```

### 2. Launch Individual Sessions

For each session (can be done via GitHub web UI or locally):

#### Option A: Launch via GitHub (Recommended)

1. Navigate to repository: `https://github.com/jcaldwell-labs/[repo-name]`
2. Click "Code" → "Open with Claude"
3. Wait for session to start
4. Provide initial instructions (see Section 3 below)

#### Option B: Launch via Local Clone

```bash
# Clone repo to separate directory
cd ~/claude-sessions
gh repo clone jcaldwell-labs/[repo-name] session-[letter]-[repo-name]
cd session-[letter]-[repo-name]

# Launch Claude Code in this directory
# Then provide initial instructions
```

### 3. Initial Instructions for Each Session

Copy this template and customize for each session:

```markdown
You are working on the jcaldwell-labs organization improvement project.

Your assignment:
- Repository: [repo-name]
- Session ID: session-[letter]
- Phase: 2 - Repository Improvements

Tasks:
1. Read ROADMAP-2025.md Phase 2 section
2. Read PARALLEL-SESSION-GUIDE.md (this file)
3. Update PARALLEL-SESSION-MANIFEST.md:
   - Set your repository status to "in_progress"
   - Add your session ID and start date
   - Commit and push this update
4. Complete the standard checklist for this repository
5. Complete any repository-specific tasks (see ROADMAP-2025.md)
6. Create PR with improvements
7. Write improvement report using templates/IMPROVEMENT-REPORT-TEMPLATE.md
8. Update PARALLEL-SESSION-MANIFEST.md:
   - Set status to "completed"
   - Add completion date, PR link, report link
   - Commit and push
9. Export your my-context session

Standard checklist location: ROADMAP-2025.md → Phase 2 → "Per-Repository Standard Checklist"

Repository-specific tasks: ROADMAP-2025.md → Phase 2 → "Repository-Specific Tasks" → [your-repo]

Work independently. If you encounter blockers, note them in the manifest and improvement report.

Time budget: [4-8 hours depending on complexity]

Ready to start? Please confirm you've read the roadmap and understand your tasks.
```

---

## Session Workflow

Each session follows this workflow:

```
START
  ↓
Claim repository (update manifest)
  ↓
Read roadmap and checklist
  ↓
Start my-context session
  ↓
Work through standard checklist
  ↓
Work through repo-specific tasks
  ↓
Run tests, verify builds
  ↓
Create PR with changes
  ↓
Write improvement report
  ↓
Export my-context session
  ↓
Update manifest (completed)
  ↓
END
```

### Detailed Steps

#### Step 1: Claim Repository

```bash
# Pull latest manifest
git pull origin master

# Edit PARALLEL-SESSION-MANIFEST.md
# Change your row from:
# | repo-name | not_started | - | - | - | - | - | - |
# To:
# | repo-name | in_progress | session-X | 2025-11-22 | - | - | - | - |

# Commit and push
git add PARALLEL-SESSION-MANIFEST.md
git commit -m "Session X: Claiming [repo-name]"
git push origin master
```

#### Step 2: Start Work

```bash
# Start my-context session
export MY_CONTEXT_HOME=db:[repo-name]_improvement
my-context start "phase2-improvement-$(date +%Y-%m-%d)"

# Take initial note
my-context note "Starting Phase 2 improvements for [repo-name]"
my-context note "Session ID: session-X"
```

#### Step 3: Execute Checklist

Work through each checklist section systematically:

**Documentation**:
```bash
# Check for CLAUDE.md
ls -la CLAUDE.md || echo "Need to create CLAUDE.md"

# Review README
cat README.md
# Add missing sections

my-context note "Documentation: Added troubleshooting section to README"
```

**Code Quality**:
```bash
# Run linter (example for C)
clang-format -i *.c
gcc -Wall -Wextra *.c  # Check for warnings

# For Go
go fmt ./...
go vet ./...

my-context note "Code Quality: Fixed 5 compiler warnings"
```

**Testing**:
```bash
# Run tests
make test || go test ./... || python -m pytest

# Check coverage
# Add tests if needed

my-context note "Testing: Added tests for feature X, coverage now 75%"
```

Continue for all sections...

#### Step 4: Create PR

```bash
# Create branch
git checkout -b improve/phase2-improvements

# Commit changes
git add .
git commit -m "Phase 2 improvements for [repo-name]

- Added comprehensive CLAUDE.md
- Improved README with troubleshooting section
- Fixed compiler warnings
- Added test coverage for feature X
- [other improvements]

Completes Phase 2 checklist for session-X."

# Push and create PR
git push -u origin improve/phase2-improvements
gh pr create --title "Phase 2: Repository improvements" \
  --body "$(cat <<EOF
## Summary
This PR implements Phase 2 improvements for [repo-name] as part of the jcaldwell-labs organization improvement initiative.

## Changes
- Documentation improvements (CLAUDE.md, README, CONTRIBUTING)
- Code quality fixes (linting, warnings, comments)
- Testing enhancements (new tests, improved coverage)
- Build system improvements (Makefile, CI)
- Project health updates (templates, settings)

## Checklist
See improvement report for detailed checklist completion.

## Related
- Improvement Report: [link when created]
- Session: session-X
- Phase: 2
- Manifest: PARALLEL-SESSION-MANIFEST.md

## Testing
- [ ] All tests passing
- [ ] Build verified
- [ ] Documentation reviewed
EOF
)"
```

#### Step 5: Write Report

```bash
# Copy template
cp ../jcaldwell-labs/templates/IMPROVEMENT-REPORT-TEMPLATE.md \
   [REPO]-IMPROVEMENT-REPORT.md

# Fill in report
# (Use your preferred editor)

# Commit report to jcaldwell-labs repo
cd ../jcaldwell-labs/reports
cp ../../[repo]/[REPO]-IMPROVEMENT-REPORT.md .
git add [REPO]-IMPROVEMENT-REPORT.md
git commit -m "Add Phase 2 improvement report for [repo-name]"
git push origin master
```

#### Step 6: Update Manifest

```bash
cd ../jcaldwell-labs

# Pull latest
git pull origin master

# Edit PARALLEL-SESSION-MANIFEST.md
# Change your row to:
# | repo-name | completed | session-X | 2025-11-22 | 2025-11-22 | #PR-NUM | reports/REPO-REPORT.md | - |

git add PARALLEL-SESSION-MANIFEST.md
git commit -m "Session X: Completed [repo-name]"
git push origin master
```

#### Step 7: Export Session

```bash
# Export my-context
my-context export > ../jcaldwell-labs/sessions/session-X-[repo-name].md

# Commit export
cd ../jcaldwell-labs
git add sessions/session-X-[repo-name].md
git commit -m "Add session export for session-X ([repo-name])"
git push origin master
```

---

## Conflict Resolution

### Manifest Conflicts

If two sessions try to update manifest simultaneously:

1. Second session gets merge conflict
2. Pull latest: `git pull origin master`
3. Resolve conflict (usually just both changes)
4. Commit and push

### Code Conflicts

Sessions work on different repos, so code conflicts should not occur.

If accidentally working on same repo:
1. First session to create PR wins
2. Second session rebases onto first PR's branch
3. Second session updates only non-conflicting items

---

## Progress Monitoring

### For Coordinator

Check manifest periodically:

```bash
# Pull latest manifest
cd ~/projects/jcaldwell-labs
git pull origin master

# View status
cat PARALLEL-SESSION-MANIFEST.md

# Count completion
grep "completed" PARALLEL-SESSION-MANIFEST.md | wc -l
```

### For Sessions

Update manifest regularly:
- When starting (claim repo)
- If blocked (note blocker)
- When completing (mark done)

---

## Time Management

### Time Budgets per Repository

- **High complexity** (fintrack, boxes-live, my-context): 6-8 hours
- **Medium complexity** (terminal-stars, tario, adventure-engine-v2): 4-6 hours
- **Low complexity** (smartterm-prototype, atari-style, .github): 2-4 hours

### Time-Boxing Strategy

If a checklist item takes longer than expected:

1. Note the issue in improvement report
2. Create GitHub issue for follow-up
3. Mark checklist item as "documented for future"
4. Move to next item

**Do not** let one item block completion of entire checklist.

### Session Timeout

If session exceeds time budget:

1. Complete current task
2. Document remaining items in improvement report
3. Create GitHub issues for unfinished work
4. Mark session as completed with notes

---

## Quality Gates

Before marking session complete, verify:

- [ ] All tests passing
- [ ] Build succeeds
- [ ] No critical compiler warnings
- [ ] Documentation updated
- [ ] PR created
- [ ] Improvement report written
- [ ] Manifest updated

**If any quality gate fails**, document in report and create follow-up issue.

---

## Special Considerations

### atari-style Critical Fix

**Session working on atari-style MUST**:
1. Read `USB-STUCK-PROCESS-DIAGNOSTIC.md`
2. Apply all recommended fixes (signal handlers, timeouts, health checks)
3. Test thoroughly
4. Document testing in improvement report

This is a **critical safety fix** to prevent system lockup.

### my-context Database Backend

When working on my-context:
- Test both database mode and file mode
- Verify PostgreSQL connection handling
- Test backup/restore
- Document configuration requirements

### .github Organization Repo

When working on .github:
- Changes affect entire organization
- Review carefully before PR
- Test templates in another repo first
- Coordinate with owner if changing policies

---

## Rollup Validation

After all sessions complete, coordinator runs validation.

### Automated Validation Script

Will be created in Phase 0: `scripts/validate-phase2.sh`

Checks:
- All repos have status "completed" in manifest
- All repos have improvement report
- All repos have PR
- All PRs link to reports
- No critical blockers

### Manual Review

Coordinator reviews:
- Each improvement report
- Each PR for quality
- Overall consistency
- Any unexpected findings

### Sign-Off

Coordinator creates: `PHASE2-SUMMARY.md`

Contains:
- Executive summary
- Statistics (files changed, tests added, issues fixed)
- Highlights (best improvements)
- Issues (blockers, follow-ups)
- Approval to proceed to Phase 3

---

## Troubleshooting

### "Manifest is out of date"

```bash
git pull --rebase origin master
# Resolve conflicts if any
git push origin master
```

### "Can't access my-context database"

```bash
# Check database running
pg_isready

# Use file mode as fallback
export MY_CONTEXT_HOME=~/.my-context-sessions/[repo-name]
my-context start "phase2-improvement"
```

### "Tests failing after changes"

1. Revert last change
2. Run tests again
3. Apply change incrementally
4. Fix test failures
5. Document in report

### "Exceeded time budget"

1. Document remaining work
2. Create GitHub issues
3. Complete session
4. Issues can be addressed later

### "Blocker preventing completion"

1. Update manifest with blocker description
2. Document in improvement report
3. Create GitHub issue
4. Complete other checklist items
5. Notify coordinator

---

## Communication

### Between Sessions

**Via Git/GitHub**:
- Commit messages
- PR descriptions
- Issue comments
- Manifest updates

**Via Reports**:
- Improvement reports in `reports/`
- Session exports in `sessions/`

### With Coordinator

**Via Manifest**:
- Status updates
- Blocker notifications
- Completion notifications

**Via Issues**:
- Create issues for blockers
- Tag coordinator if urgent

---

## Session Completion Checklist

Before ending your session:

- [ ] All checklist items addressed (or documented as future work)
- [ ] Tests passing
- [ ] Build succeeds
- [ ] PR created and linked
- [ ] Improvement report written and committed
- [ ] Manifest updated to "completed"
- [ ] my-context session exported
- [ ] No critical blockers
- [ ] All commits pushed
- [ ] All files saved

**If all checked**, session is complete! 🎉

---

## Post-Session

After session completes:

1. Coordinator reviews PR
2. Coordinator reviews improvement report
3. Coordinator merges PR or requests changes
4. Session addresses any change requests
5. PR merged
6. Stats updated in summary

---

## Templates and References

### Quick Reference

- Roadmap: `ROADMAP-2025.md`
- Standard Checklist: `ROADMAP-2025.md` → Phase 2
- Report Template: `templates/IMPROVEMENT-REPORT-TEMPLATE.md`
- Manifest: `PARALLEL-SESSION-MANIFEST.md`
- This Guide: `PARALLEL-SESSION-GUIDE.md`

### Example Session

See: `examples/SESSION-EXAMPLE.md` (to be created)

Shows complete session flow for a sample repository.

---

## FAQ

**Q: Can I work on multiple repos in one session?**
A: Yes, if they're low complexity. See Session G assignment.

**Q: What if I find a critical security issue?**
A: Fix immediately, note in report, create security advisory if needed.

**Q: What if tests are already failing before I start?**
A: Document in report, fix if possible, create issue if not.

**Q: Can I refactor code?**
A: Only if it improves quality without breaking functionality. Keep scope limited.

**Q: What if there's no test suite?**
A: Create basic test suite or document that it's needed for future work.

**Q: How detailed should commit messages be?**
A: Descriptive but concise. Detail goes in PR description and improvement report.

**Q: What if I disagree with a checklist item?**
A: Note in report why it's not applicable. Use judgment.

**Q: Can I add features?**
A: Only if they're quick wins related to checklist items. Primary focus is quality/docs/tests.

---

**Document Version**: 1.0
**Last Updated**: 2025-11-22
**Questions?**: Create issue in jcaldwell-labs/jcaldwell-labs repo
