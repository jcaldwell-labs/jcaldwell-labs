# PR Failure Handling Protocol

**Purpose**: Clear decision tree for when initial Pull Requests fail CI/CD checks

**Created**: 2025-11-23 (from Phase 2 lessons learned)

**Problem Solved**: Phase 2 had "no structure prepared for when the initial large PRs had issues", leading to multiple PRs per repository and confusion about whether to fix in place or start fresh.

---

## Quick Decision Tree

```
PR fails CI/CD
    │
    ├─ Failure Type?
    │
    ├─ FORMATTING / LINTING
    │   ├─ Action: FIX IN PLACE
    │   ├─ Command: Run linter locally, fix issues, push to same branch
    │   ├─ Time: < 15 minutes
    │   └─ Expected: CI passes on next run
    │
    ├─ TEST FAILURES (1-3 tests)
    │   ├─ Action: FIX IN PLACE
    │   ├─ Command: Debug locally, fix tests, push to same branch
    │   ├─ Time: < 60 minutes
    │   └─ Expected: All tests pass on next run
    │
    ├─ TEST FAILURES (4+ tests or architectural)
    │   ├─ Action: EVALUATE
    │   ├─ Quick fix possible? → FIX IN PLACE
    │   ├─ Requires rethinking? → CLOSE PR, CREATE ISSUE, START FRESH
    │   ├─ Time: 30 min evaluation
    │   └─ Expected: Clear decision within 30 minutes
    │
    ├─ BUILD FAILURES
    │   ├─ Action: FIX IN PLACE (if dependency/config issue)
    │   ├─ Action: CLOSE PR (if architectural problem)
    │   ├─ Time: < 30 minutes to decide
    │   └─ Expected: Build succeeds or new approach needed
    │
    ├─ SECURITY SCAN FALSE POSITIVE
    │   ├─ Action: ESCALATE TO MANUAL REVIEW
    │   ├─ Steps:
    │   │   1. Document why it's false positive
    │   │   2. Check if gosec (real security scan) passes
    │   │   3. If gosec passes, fix PR validation workflow
    │   │   4. Do NOT spend >30 min trying to satisfy broken check
    │   ├─ Example: Phase 2 fintrack PR #9 (wasted 7+ commits on false positive)
    │   └─ Lesson: If check is broken, fix the check, not the code
    │
    ├─ SECURITY SCAN REAL ISSUE
    │   ├─ Action: FIX IMMEDIATELY
    │   ├─ Priority: CRITICAL
    │   ├─ Steps:
    │   │   1. Remove hardcoded credentials/secrets
    │   │   2. Use environment variables
    │   │   3. Update documentation
    │   │   4. Verify with Security Scan (gosec)
    │   └─ Expected: No credentials in code or config
    │
    ├─ COPILOT REVIEW FEEDBACK (minor)
    │   ├─ Action: FIX IN PLACE
    │   ├─ Address: Code style, naming, documentation
    │   ├─ Time: < 30 minutes
    │   └─ Expected: Quality improvements
    │
    ├─ COPILOT REVIEW FEEDBACK (major)
    │   ├─ Action: EVALUATE
    │   ├─ If architectural change needed → Consider new PR
    │   ├─ If refactoring suggested → Decide: scope creep or valid improvement?
    │   ├─ Time: 30 min evaluation
    │   └─ Expected: Clear decision, possibly defer improvements
    │
    └─ COVERAGE REGRESSION
        ├─ Action: FIX IN PLACE
        ├─ Steps: Add tests for new code paths
        ├─ Time: < 60 minutes
        └─ Expected: Coverage maintained or improved
```

---

## Protocol Details

### 1. FIX IN PLACE (Recommended for most failures)

**When to use:**
- Linting/formatting issues
- 1-3 test failures
- Minor code quality issues
- Copilot review feedback (minor)
- Coverage gaps
- Build configuration issues

**Process:**
1. **Pull latest from PR branch**
   ```bash
   git checkout [pr-branch-name]
   git pull origin [pr-branch-name]
   ```

2. **Reproduce failure locally**
   ```bash
   make lint
   make test
   make build
   ```

3. **Fix issues**
   - Address specific CI failures
   - Run local validation until passing
   - Self-review changes

4. **Push fix to same branch**
   ```bash
   git add [fixed-files]
   git commit -m "fix: Address CI failures - [specific issue]"
   git push
   ```

5. **Monitor CI**
   - Wait for CI to complete
   - Verify all checks pass
   - If still failing: repeat steps 2-4 (max 3 iterations)
   - If 3 iterations fail: escalate to EVALUATE

**Example commit messages:**
- `fix: Address linter errors in runner.go`
- `fix: Correct test expectations in usage_test.go`
- `fix: Remove unused imports flagged by CI`

**Phase 2 Success Example:**
- terminal-stars PR #8: All 13 Copilot review items fixed in place → merged successfully

### 2. CLOSE PR & START FRESH

**When to use:**
- Architectural problems discovered
- 4+ test failures indicating design flaw
- Scope creep detected (PR doing too much)
- After 3 fix iterations still failing
- Wrong approach entirely

**Process:**
1. **Document learnings**
   - What was attempted
   - Why it didn't work
   - What approach would work better

2. **Create GitHub issue**
   - Title: `[Feature]: [Original PR goal]`
   - Body: Link to closed PR, explain why closed, proposed new approach
   - Label: `needs-redesign`

3. **Close PR with comment**
   ```
   Closing this PR due to [architectural issues / wrong approach / too complex].

   Learnings:
   - [What didn't work]
   - [Why it failed]

   Next steps tracked in issue #[number]
   - [New approach]
   - [Simplified scope]
   ```

4. **Create new PR** (if ready)
   - Smaller scope
   - Different approach
   - Apply learnings

5. **Delete branch** (after PR closed)
   ```bash
   git branch -D [old-pr-branch]
   git push origin --delete [old-pr-branch]
   ```

**Phase 2 Example:**
- fintrack PR #9: Closed after 7+ commits fighting security false positives
- Reason: PR became too complex, obscured original feature
- Outcome: Closed with explanation, feature deferred to future simpler PR

### 3. EVALUATE (Decision needed)

**When to use:**
- Unclear if fix-in-place or close is better
- Major Copilot feedback requiring architectural changes
- Time spent on fixes exceeds 1 hour
- Multiple types of failures

**Process:**
1. **Time-box evaluation**: 30 minutes maximum

2. **Ask these questions:**
   - Can I fix this in < 2 hours total effort?
   - Is the fix aligned with original PR scope?
   - Will fixing this improve code quality?
   - Is there a simpler approach I'm missing?
   - Have I spent > 1 hour on fixes already?

3. **Decision matrix:**
   ```
   Can fix in < 2 hours?
   ├─ YES + aligned with scope → FIX IN PLACE
   └─ NO or scope creep → CLOSE & START FRESH

   Already spent > 1 hour on fixes?
   └─ YES → CLOSE & START FRESH (diminishing returns)

   Architectural change needed?
   └─ YES → CLOSE & START FRESH (wrong approach)
   ```

4. **Document decision** in PR comment or issue

**Phase 2 Example:**
- fintrack PR #9 should have been CLOSED after 3rd security scan iteration
- Actual: Continued for 7+ iterations, wasted time
- Lesson: Evaluate earlier, don't persist with broken approach

### 4. ESCALATE (Manual review needed)

**When to use:**
- Security scan false positive suspected
- CI check appears broken/wrong
- Conflicting feedback from different checks
- Blocker outside your control

**Process:**
1. **Document the issue**
   - Which check is failing
   - Why you believe it's a false positive
   - Evidence supporting your case

2. **Verify with alternative tools**
   - Security: Check if gosec passes (authoritative security scan)
   - Linting: Run golangci-lint locally
   - Tests: Run full test suite locally

3. **Create escalation issue**
   ```
   Title: [Escalation] CI check appears broken: [check name]

   Problem:
   - Check: [name]
   - Failure: [message]
   - Reason it's false positive: [explanation]

   Evidence:
   - [Alternative tool] shows: [result]
   - Local validation: [passed/failed]
   - PR is actually: [improving/fixing security, etc.]

   Request: Manual review of [check name] or workflow fix
   ```

4. **Update manifest** with "escalated" status

5. **Move to other work** while waiting for resolution

**Phase 2 Example:**
- fintrack PR #9 security scan detected REMOVAL of credentials as violation
- Should have escalated after 2nd attempt
- Instead: Spent 7+ commits trying to satisfy broken check
- Resolution: Eventually fixed the check itself, not the code

---

## Key Principles

### Principle 1: Fix Forward, Not Sideways
**Don't create new PRs to fix old PRs**

❌ Bad Pattern (Phase 2 fintrack):
- PR #4: Main feature
- PR #5: Fix issues from PR #4
- PR #6: Fix issues from PR #5
- Result: 4 PRs instead of 1

✅ Good Pattern:
- PR #4: Main feature
- CI fails: Fix in same PR by pushing to same branch
- Result: 1 clean PR

### Principle 2: Three-Strike Rule
**After 3 fix iterations, stop and evaluate**

- Iteration 1: Fix the obvious issues
- Iteration 2: Fix the less obvious issues
- Iteration 3: If still failing, something is fundamentally wrong
- **Action**: CLOSE PR and rethink approach

### Principle 3: Time-Box Everything
**Don't spend unlimited time on fixes**

- Quick fixes: < 30 minutes
- Test fixes: < 60 minutes
- Evaluation: 30 minutes max
- **Total**: If >2 hours spent on fixes, CLOSE and START FRESH

### Principle 4: Scope Protection
**Don't let PR fixes cause scope creep**

❌ Original PR: Add feature X
❌ CI feedback: Refactor module Y, improve Z, add docs for A, B, C
❌ Result: PR now does 5 things instead of 1

✅ Original PR: Add feature X
✅ CI feedback: Minor code style fixes
✅ Result: PR still focused on feature X

**If feedback suggests major changes**: Create follow-up issues, keep PR focused

### Principle 5: Don't Fix Broken Checks
**If the check is wrong, fix the check**

Phase 2 Lesson: fintrack PR #9 spent 7 commits trying to satisfy a broken security check that flagged credential REMOVAL as a violation.

**Better approach:**
1. Attempt 1: Try to satisfy check
2. Attempt 2: Verify it's really broken (check gosec, run locally)
3. Attempt 3: Fix the check itself or escalate
4. **DO NOT** spend >3 attempts satisfying a broken check

---

## Pre-PR Validation (Prevent failures)

**BEFORE creating any PR, validate locally:**

```bash
# Run pre-PR validation script
./scripts/pre-pr-check.sh

# Manual checks if script not available:
make clean
make build     # Must succeed with ZERO warnings
make test      # Must pass 100%
make lint      # Must be clean

git diff       # Self-review every changed line
```

**If any check fails locally, DO NOT create PR**

Phase 2 Lesson: Most CI failures could have been prevented with local validation before PR creation.

---

## Templates

### Template: Fix-In-Place Commit Message
```
fix: [Brief description of CI failure addressed]

- [Specific change 1]
- [Specific change 2]

Addresses CI failure: [check name]
Related: [PR number]
```

### Template: Close PR Comment
```
Closing this PR due to [reason].

## What was attempted
- [Approach 1]
- [Approach 2]

## Why it didn't work
- [Issue 1]
- [Issue 2]

## Learnings
- [Lesson 1]
- [Lesson 2]

## Next steps
New approach tracked in issue #[number]:
- [Better approach]
- [Simplified scope]
- [Alternative solution]

Thank you for the feedback during review. The work here informs the better approach.
```

### Template: Escalation Issue
```
# [Escalation] CI check appears broken: [check name]

## Problem
**Check**: [name of failing check]
**Failure message**:
```
[exact error message]
```

**Why this appears to be a false positive**:
[Explanation]

## Evidence
- **[Alternative tool]**: [result]
- **Local validation**: [result]
- **What PR actually does**: [improving security / removing credentials / etc.]

## Request
Manual review of [check name] or fix the check workflow to:
- [Suggested fix to workflow]

## Related
- PR: #[number]
- Commit: [hash]
- Workflow file: [path]
```

---

## Phase 3 Integration

**For Phase 3**, this protocol is **MANDATORY** before creating any PR:

1. **Read this protocol** - Understand decision tree
2. **Run pre-PR validation** - Ensure all local checks pass
3. **Create PR** - Only after validation passes
4. **Monitor CI** - Watch for failures
5. **Apply protocol** - Use decision tree if failures occur
6. **Don't repeat Phase 2** - No multi-PR chaos

**Session prompts** must include:
- Link to this protocol
- Mandatory pre-PR validation requirement
- Decision tree quick reference
- Three-strike rule reminder

---

## Metrics

**Success metrics for this protocol:**
- Single PR per repository per task (no multi-PR situations)
- < 2 fix iterations per PR on average
- < 5% of PRs require CLOSE & START FRESH
- Zero escalations for broken checks (checks should be fixed first)

**Track in Phase 3:**
- Number of PRs per repository
- Number of fix iterations per PR
- Time spent on fixes vs implementation
- Escalations count

---

**Version**: 1.0
**Created**: 2025-11-23
**Author**: Phase 2 retrospective learnings
**Status**: Active for Phase 3 and beyond
