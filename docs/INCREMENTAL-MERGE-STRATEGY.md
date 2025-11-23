# Incremental Merge Strategy

**Purpose**: Break large tasks into small, independently mergeable Pull Requests

**Created**: 2025-11-23 (from Phase 2 lessons learned)

**Problem Solved**: Phase 2 had large comprehensive PRs (example: boxes-live +3,472 lines) that were hard to review, more likely to fail CI, and slow to merge. Breaking work into incremental PRs reduces risk and accelerates delivery.

---

## Core Concept

Instead of:
```
❌ One large PR with everything
   - Hard to review
   - High failure risk
   - All-or-nothing merge
   - Long feedback cycles
```

Do this:
```
✅ Multiple small PRs, each independently valuable
   - Easy to review (< 300 lines ideal)
   - Low failure risk per PR
   - Can merge parts even if other parts blocked
   - Fast feedback cycles
```

---

## Benefits

### 1. Reduced Blast Radius
**Small PR fails CI → Small fix needed**

- Large PR: 3,000 lines changed, test fails → find needle in haystack
- Small PR: 200 lines changed, test fails → obvious where problem is

### 2. Faster Reviews
**Reviewers can approve small PRs quickly**

- Large PR: "I'll review this when I have 2 hours" → delayed
- Small PR: "I can review this in 15 minutes" → immediate

### 3. Continuous Integration (Literal)
**Merge work as you go, not all at end**

- Large PR: All work lands at once, potential conflicts with other work
- Small PRs: Work integrates continuously, conflicts detected early

### 4. Partial Success Possible
**Can complete 80% even if 20% blocked**

- Large PR: One blocker → entire PR stuck
- Small PRs: One blocker → 80% already merged, only 20% stuck

### 5. Easier Rollback
**If something breaks, small rollback**

- Large PR: Revert 3,000 lines → loses all work
- Small PR: Revert 200 lines → keeps 2,800 lines of good work

---

## How to Break Down Work

### Strategy 1: Layered Approach
**Build foundation first, then features on top**

Example: Unified Build System (Phase 3a)

```
Layer 1: Foundation
├─ PR 1: Create root Makefile with help target only
└─ Merge: Makefile exists, make help works

Layer 2: Language-Specific Targets
├─ PR 2: Add build-c-all target (C projects only)
├─ PR 3: Add test-c-all target (C projects only)
├─ Merge: Can build/test all C projects
├─ PR 4: Add build-go-all target (Go projects only)
├─ PR 5: Add test-go-all target (Go projects only)
└─ Merge: Can build/test all Go projects

Layer 3: Combined Targets
├─ PR 6: Add build-all target (calls build-c-all + build-go-all)
├─ PR 7: Add test-all target (calls test-c-all + test-go-all)
└─ Merge: Single command builds/tests everything

Layer 4: Documentation
├─ PR 8: Update README with build system usage
└─ Merge: Fully documented
```

**Benefits**:
- Each layer builds on previous
- Can use Layer 1 immediately after PR 1 merges
- Failure in Layer 3 doesn't block Layer 1 & 2

### Strategy 2: Feature Slicing
**Implement one complete slice at a time**

Example: my-context Integration (Phase 3b)

```
Slice 1: Design & Documentation
├─ PR 1: Document integration pattern
└─ Merge: Others can review approach before implementation

Slice 2: One Complete Integration
├─ PR 2: fintrack + my-context integration (code)
├─ PR 3: fintrack integration tests
├─ PR 4: fintrack integration docs
└─ Merge: One fully working example exists

Slice 3: Pattern Documentation
├─ PR 5: Extract pattern from fintrack example
├─ PR 6: Create integration guide for other projects
└─ Merge: Other projects can follow pattern
```

**Benefits**:
- Each slice is independently valuable
- Slice 1 can be reviewed before coding starts
- Slice 2 proves the approach works
- Slice 3 scales the pattern

### Strategy 3: Dependency Ordering
**Order PRs by what depends on what**

Example: Cross-Project Feature

```
PR 1: Add shared interface (no implementation)
    ↓ (depends on)
PR 2: Implement interface in Project A
    ↓ (parallel)  ↓ (depends on PR 1)
PR 3: Tests for Project A  PR 4: Implement in Project B
    ↓ (merge 2 & 3)         ↓ (depends on PR 1)
PR 5: Documentation         PR 5: Tests for Project B
                           ↓ (merge 4 & 5)
                        PR 6: Documentation
```

**Benefits**:
- Clear dependency chain
- Can merge PR 1 immediately (foundational)
- PR 2 & 4 can work in parallel (independent)
- Tests and docs follow implementation

### Strategy 4: Risk-Based Ordering
**Low-risk changes first, high-risk changes last**

Example: Refactoring Project

```
Low Risk (merge first):
├─ PR 1: Add tests for existing behavior
├─ PR 2: Add documentation
└─ PR 3: Extract helper functions (no behavior change)

Medium Risk (merge next):
├─ PR 4: Refactor module A (well-tested)
└─ PR 5: Update calls to module A

High Risk (merge last):
├─ PR 6: Refactor module B (complex logic)
└─ PR 7: Integration testing
```

**Benefits**:
- Safe changes merged quickly
- Build confidence with successful merges
- Risky changes come after foundation solid

---

## Size Guidelines

### Ideal PR Size
**Target: 100-300 lines changed**

- Sweet spot for reviewability
- Low failure risk
- Fast to understand

### Maximum PR Size
**Hard limit: 500 lines changed**

- Above 500 lines: Consider splitting
- Exception: Auto-generated code, test data

### Minimum PR Size
**No minimum, but must be independently valuable**

- 10-line PR is fine if it adds value
- Don't artificially inflate to meet size target

### How to Count
```bash
# Count lines changed in your branch
git diff origin/main --shortstat

# Example output:
# 247 files changed, 1234 insertions(+), 567 deletions(-)
# Focus on insertions + deletions: 1234 + 567 = 1801 lines

# If > 500 lines, consider splitting
```

---

## Examples from Phase 2

### Anti-Pattern: boxes-live PR #13
**What Happened**:
- Single PR: +3,472 lines
- Combined: CI/CD + docs + tests + features
- Result: Hard to review, slow to merge

**What Should Have Happened**:
```
PR 13.1: Add CI/CD workflow (~200 lines)
PR 13.2: Add CONTRIBUTING.md (~350 lines)
PR 13.3: Add issue templates (~100 lines)
PR 13.4: Add PR template (~50 lines)
PR 13.5: Update README (~100 lines)

Total: 5 PRs, each < 400 lines, same total work
Benefits: Each PR mergeable independently, faster reviews
```

### Good Pattern: fintrack PRs #6, #7, #8
**What Happened**:
- PR #6: Formatting fixes (focused, small)
- PR #7: Category management (single feature)
- PR #8: errcheck fixes (focused, small)
- Result: All merged successfully

**Why It Worked**:
- Each PR had single clear purpose
- Easy to review
- Fast feedback cycles
- Low failure risk

### Lesson: Terminal-stars
**Successful approach**:
- Multiple PRs (#1-7) each adding one feature
- PR #8 consolidated Phase 2 improvements
- Each PR independently valuable

**Result**: All merged, clean history

---

## Template: Task Breakdown

For each Phase 3 task, use this template:

```markdown
## Task: [Task Name]

### Overall Goal
[What needs to be accomplished]

### Breakdown into PRs

#### PR 1: [Foundation/Setup]
**What**: [Description]
**Files**: [Estimated files changed]
**Size**: ~[X] lines
**Dependencies**: None
**Value**: [What this enables]
**Success Criteria**: [How to verify]

#### PR 2: [Next Layer]
**What**: [Description]
**Files**: [Estimated files changed]
**Size**: ~[X] lines
**Dependencies**: PR 1 merged
**Value**: [What this adds]
**Success Criteria**: [How to verify]

[Repeat for each PR]

### Total Work
- Total PRs: [N]
- Total estimated lines: ~[X]
- Average PR size: ~[X/N] lines
- Estimated time: [X] hours

### Merge Order
1. PR 1 (foundation)
2. PR 2 & 3 (parallel if independent)
3. PR 4 (depends on 2 & 3)
[etc.]

### Risk Assessment
- **Low risk**: PR [numbers]
- **Medium risk**: PR [numbers]
- **High risk**: PR [numbers]
```

---

## Phase 3 Task Breakdowns

### Task 3a.1: Root Makefile Skeleton

```markdown
#### PR 1: Create Makefile with help target
**What**: Add root Makefile with only help/documentation
**Files**: Makefile (new)
**Size**: ~50 lines
**Dependencies**: None
**Value**: Foundation for all future targets
**Success**: `make help` shows available targets

#### PR 2: Add directory structure documentation
**What**: Document where each project lives
**Files**: Makefile (add comments), README.md
**Size**: ~100 lines
**Dependencies**: PR 1 merged
**Value**: Developers understand organization
**Success**: README clearly shows project layout
```

### Task 3a.2: C Projects Integration

```markdown
#### PR 3: Add build-c-all target
**What**: Single target to build all C projects
**Files**: Makefile, scripts/build-c-projects.sh
**Size**: ~150 lines
**Dependencies**: PR 1, PR 2 merged
**Value**: One command builds all C code
**Success**: `make build-c-all` succeeds with zero warnings

#### PR 4: Add test-c-all target
**What**: Single target to test all C projects
**Files**: Makefile, scripts/test-c-projects.sh
**Size**: ~150 lines
**Dependencies**: PR 3 merged (needs build to test)
**Value**: One command runs all C tests
**Success**: `make test-c-all` runs all test suites
```

### Task 3a.3: Go Projects Integration

```markdown
#### PR 5: Add build-go-all target
**What**: Single target to build all Go projects
**Files**: Makefile, scripts/build-go-projects.sh
**Size**: ~100 lines
**Dependencies**: PR 1, PR 2 merged
**Value**: One command builds all Go code
**Success**: `make build-go-all` succeeds with zero warnings

#### PR 6: Add test-go-all target
**What**: Single target to test all Go projects
**Files**: Makefile, scripts/test-go-projects.sh
**Size**: ~100 lines
**Dependencies**: PR 5 merged
**Value**: One command runs all Go tests
**Success**: `make test-go-all` passes 100%
```

### Task 3a.4: Combined Targets

```markdown
#### PR 7: Add build-all target
**What**: Single target calling build-c-all + build-go-all
**Files**: Makefile
**Size**: ~50 lines
**Dependencies**: PR 3, PR 5 merged
**Value**: Build entire organization with one command
**Success**: `make build-all` builds all projects

#### PR 8: Add test-all target
**What**: Single target calling test-c-all + test-go-all
**Files**: Makefile
**Size**: ~50 lines
**Dependencies**: PR 4, PR 6, PR 7 merged
**Value**: Test entire organization with one command
**Success**: `make test-all` runs all tests

#### PR 9: Update documentation
**What**: README with complete build system usage
**Files**: README.md, docs/BUILD-SYSTEM.md
**Size**: ~200 lines
**Dependencies**: PR 7, PR 8 merged
**Value**: Fully documented build system
**Success**: New contributor can follow README and build successfully
```

**Total for Task 3a**: 9 PRs, ~850 lines, avg ~94 lines per PR

---

## Decision Tree: Should I Split This PR?

```
Is PR > 500 lines?
├─ YES → Split (required)
└─ NO → Continue evaluation

Does PR do > 1 thing?
├─ YES → Consider splitting by responsibility
│   Examples:
│   - Feature + tests → Split into 2 PRs
│   - Multiple features → Split per feature
│   - Setup + implementation → Split into layers
└─ NO → Continue evaluation

Can PR be split without breaking functionality?
├─ YES → Consider splitting for easier review
└─ NO → Keep as single PR

Is PR higher risk?
├─ YES → Split to isolate risky changes
└─ NO → Single PR acceptable

Final decision:
├─ < 300 lines, single purpose → ✅ Good as-is
├─ 300-500 lines, single purpose → ✅ Acceptable
├─ > 500 lines OR multiple purposes → ❌ Split required
└─ High risk regardless of size → Consider splitting
```

---

## Commit Strategy Within PR

**Each PR should have 1-3 commits**:

1. **Single commit** (ideal):
   ```
   feat: add build-c-all target

   - Create Makefile target
   - Add build script
   - Update documentation
   ```

2. **Two commits** (if fix needed):
   ```
   Commit 1: feat: add build-c-all target
   Commit 2: fix: address linter errors in build script
   ```

3. **Three commits** (maximum):
   ```
   Commit 1: feat: add build-c-all target
   Commit 2: test: add tests for build script
   Commit 3: docs: update README with new target
   ```

**Do NOT**:
- Have 10+ commits in a PR (squash before merge)
- Have "fix typo" commits (amend previous commit)
- Have "WIP" commits in final PR

---

## Integration with Phase 3

**Phase 3 Requirements**:

1. **All tasks must be broken down** into 2-9 PRs using this strategy
2. **Task breakdown must be in roadmap** before session starts
3. **PRs must be created in documented order** (respect dependencies)
4. **Each PR must be independently mergeable** and valuable
5. **No PR should exceed 500 lines** without explicit justification

**Session prompts must include**:
- Task breakdown with PR plan
- Merge order specification
- Size guidelines
- Value statement per PR

**Success metrics**:
- Average PR size < 300 lines
- > 90% of PRs merge on first or second attempt
- Zero PRs > 500 lines without justification

---

## Key Principles

### Principle 1: Small Batches Flow Faster
**Manufacturing wisdom applies to code**

Small PRs move through the system faster than large PRs, even though there are more of them.

### Principle 2: Independently Valuable
**Each PR should stand alone**

Don't create throwaway PRs. Each should add real value even if subsequent PRs don't land.

### Principle 3: Merge Continuously
**Don't wait to merge until "everything" is done**

Merge each PR as soon as it's ready. Don't batch merges.

### Principle 4: Fail Fast, Recover Fast
**Small PR fails → Small fix**

Better to have a small PR fail (easy fix) than large PR fail (hard fix).

---

**Version**: 1.0
**Created**: 2025-11-23
**Author**: Phase 2 retrospective learnings
**Status**: Active for Phase 3 and beyond
