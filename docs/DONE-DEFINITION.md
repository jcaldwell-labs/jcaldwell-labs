# "Done Done" Definition

**Purpose**: Explicit criteria for when a task is truly complete

**Created**: 2025-11-23 (from Phase 2 lessons learned)

**Problem Solved**: Phase 2 had vague completion criteria, leading to sessions considering work "done" when PR was created but CI was failing. This caused 60% time overruns as fix cycles weren't accounted for in "done" estimates.

---

## What "Done Done" Means

A task is **"Done Done"** when **ALL** of these criteria are met:

### 1. Code Complete ✅
- [ ] All code changes implemented
- [ ] All files saved and committed
- [ ] Git working directory clean (no uncommitted changes)
- [ ] Commit messages follow conventions

### 2. Local Validation Passed ✅
- [ ] `make clean && make build` succeeds with **zero warnings**
- [ ] `make test` passes with **100% success rate**
- [ ] `make lint` (or equivalent) reports **zero issues**
- [ ] Self-reviewed `git diff` line-by-line
- [ ] No debug code (console.log, print statements, etc.)
- [ ] No TODO/FIXME comments without associated issues

### 3. PR Created and Passing ✅
- [ ] PR created on GitHub
- [ ] PR description comprehensive (what, why, how to test)
- [ ] CI/CD checks **all passing** (green checkmarks)
- [ ] No failing tests in CI
- [ ] No linter errors in CI
- [ ] Security scans passing
- [ ] Build succeeds on all platforms

### 4. Review Addressed ✅
- [ ] Copilot review feedback addressed (if applicable)
- [ ] Human review requested
- [ ] All review comments responded to
- [ ] Changes requested in review have been made

### 5. Documentation Complete ✅
- [ ] Improvement report written and committed
- [ ] my-context session exported
- [ ] Changes documented in CHANGELOG (if applicable)
- [ ] README updated (if applicable)
- [ ] API docs updated (if applicable)

### 6. Tracking Updated ✅
- [ ] Manifest updated with "completed" status
- [ ] Session marked complete in tracking system
- [ ] PR linked in manifest/tracking
- [ ] Report linked in manifest/tracking

### 7. Ready to Merge ✅
- [ ] All above criteria met
- [ ] Branch up to date with main
- [ ] No merge conflicts
- [ ] Approved by reviewer (if required)
- [ ] Ready to click "Merge" button

---

## What is NOT "Done"

### ❌ NOT Done: PR Created But CI Failing
```
Status:
✓ Code written
✓ PR created
✗ CI showing red X
✗ Tests failing
✗ Linter errors

This is: ~70% done
Time remaining: Unknown (could be 5 min or 5 hours)
```

**Phase 2 Example**: Many initial PRs were considered "done" by sessions but required hours of fix cycles.

### ❌ NOT Done: PR Passing But No Report
```
Status:
✓ Code written
✓ PR created
✓ CI passing
✗ Improvement report missing
✗ Manifest not updated

This is: ~85% done
Time remaining: 30-60 min
```

**Phase 2 Example**: Only 1/8 repos completed improvement reports, making rollup difficult.

### ❌ NOT Done: Work Complete Locally But Not Pushed
```
Status:
✓ Code written
✓ Tests passing locally
✗ Changes not committed
✗ Not pushed to GitHub
✗ No PR created

This is: ~40% done
Time remaining: 1-2 hours (for PR creation and CI)
```

### ❌ NOT Done: Tests Pass Locally But CI Not Run
```
Status:
✓ Code written
✓ Tests pass locally
✓ Committed and pushed
✗ No PR created (so no CI run)
✗ Unknown if CI will pass

This is: ~60% done
Time remaining: 1-2 hours (for PR and potential CI fixes)
```

---

## Time Estimation Based on "Done Done"

### Phase 2 Mistake
**Estimated**: 4-6 hours per repository
**Scoped as**: Time to write code and create PR
**Actual**: 8-10 hours per repository
**Actual included**: Code writing + PR creation + CI fixes + review responses

**Lesson**: Estimate must include **everything** to reach "done done", not just initial coding.

### Phase 3 Correct Estimation

For each task, estimate:

```
Base time (coding):              X hours
+ CI fix cycles (50% buffer):    +50% = 0.5X hours
+ Review responses (25% buffer): +25% = 0.25X hours
+ Documentation:                 +20% = 0.2X hours
─────────────────────────────────────────
Total to "done done":            1.95X hours ≈ 2X hours
```

**Example**:
- Task: Add build-c-all target
- Base estimate: 2 hours (write Makefile target + script)
- With buffers: 2 × 1.95 = 3.9 hours ≈ 4 hours
- **Use 4 hours in planning**

**This accounts for**:
- Initial PR creation: 2 hours
- CI fails, one fix cycle: +1 hour (50% buffer)
- Copilot review feedback: +0.5 hours (25% buffer)
- Write improvement report notes: +0.4 hours (20% buffer)
- **Total**: ~4 hours to "done done"

---

## Checkpoints

Use these checkpoints to verify progress toward "done done":

### Checkpoint 1: Code Complete (40% done)
```
✓ All code written
✓ Committed to branch
✓ Self-reviewed

Next: Local validation
Remaining: 60% (validation, PR, CI, review, docs)
```

### Checkpoint 2: Local Validation Passed (60% done)
```
✓ Code complete
✓ make test passing
✓ make lint clean
✓ make build succeeding

Next: Create PR
Remaining: 40% (PR creation, CI, review, docs)
```

### Checkpoint 3: PR Created (70% done)
```
✓ Code complete
✓ Local validation passed
✓ PR created on GitHub

Next: Wait for CI
Remaining: 30% (CI passes, review, docs)
```

### Checkpoint 4: CI Passing (85% done)
```
✓ Code complete
✓ Local validation passed
✓ PR created
✓ CI all green checkmarks

Next: Address review, write report
Remaining: 15% (review, docs, tracking)
```

### Checkpoint 5: Review Addressed (95% done)
```
✓ Code complete
✓ Local validation passed
✓ PR created
✓ CI passing
✓ Review feedback addressed

Next: Documentation and tracking
Remaining: 5% (report, manifest, export)
```

### Checkpoint 6: "Done Done" (100%)
```
✓ All criteria met
✓ Ready to merge
✓ Can move to next task

Next: Merge PR, start next task
Remaining: 0%
```

---

## Integration with Phase 3

**For Phase 3**, "done done" is **enforced** via:

1. **Task cannot be marked complete** in manifest until all criteria met
2. **Sessions cannot claim** next task until current task is "done done"
3. **Time estimates** must use the 2X buffer formula
4. **Quality gates** check for all 7 criteria before allowing "complete" status

**Session prompts must include**:
- Complete "done done" checklist
- Checkpoint tracking
- Estimation formula
- No shortcuts allowed

**Manifests must track**:
- Current checkpoint for each task
- Estimated completion percentage
- Blockers preventing "done done"

**Success metrics for Phase 3**:
- 100% of tasks meet "done done" before marked complete
- Zero instances of "PR created but CI failing" marked as done
- Time estimates within 20% of actuals

---

## Phase 2 vs Phase 3 Comparison

### Phase 2 (Vague "Done")
```
Session creates PR → marked "done"
├─ CI fails → NOT factored into "done" time
├─ Review feedback → NOT factored into "done" time
├─ No report → Still considered "done"
└─ Result: 60% time overrun, messy completion state
```

### Phase 3 (Explicit "Done Done")
```
Session creates PR → ~70% done
├─ Wait for CI to pass → 85% done
├─ Address review → 95% done
├─ Write report & update tracking → 100% done
└─ Result: Realistic estimates, clean completion
```

---

## Templates

### Template: "Done Done" Checklist for PR
```markdown
## Done Done Checklist

Before marking this task complete, verify ALL items:

**Code Complete**:
- [ ] All changes implemented
- [ ] Committed with clear messages
- [ ] Working directory clean

**Local Validation**:
- [ ] `make build` succeeds (zero warnings)
- [ ] `make test` passes (100% success)
- [ ] `make lint` clean (zero errors)
- [ ] Self-reviewed diff line-by-line
- [ ] No debug code remaining

**PR Status**:
- [ ] PR created: #[number]
- [ ] CI passing: [link to checks]
- [ ] Description comprehensive
- [ ] All checks green

**Review**:
- [ ] Copilot feedback addressed
- [ ] Human review requested
- [ ] Comments responded to

**Documentation**:
- [ ] Improvement report: [link]
- [ ] my-context exported: [link]
- [ ] CHANGELOG updated (if applicable)
- [ ] README updated (if applicable)

**Tracking**:
- [ ] Manifest updated: "completed"
- [ ] PR linked in manifest
- [ ] Report linked in manifest

**Ready to Merge**:
- [ ] No merge conflicts
- [ ] Branch up to date
- [ ] Approved (if required)
- [ ] Can click "Merge" button

**Status**: [% complete based on checkpoints above]
```

---

**Version**: 1.0
**Created**: 2025-11-23
**Author**: Phase 2 retrospective learnings
**Status**: Active for Phase 3 and beyond
**Related**: ESCALATION-PROTOCOL.md, PR-FAILURE-PROTOCOL.md
