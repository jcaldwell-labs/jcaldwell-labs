# Escalation Protocol

**Purpose**: Clear path for handling blockers and issues that cannot be resolved quickly

**Created**: 2025-11-23 (from Phase 2 lessons learned)

**Problem Solved**: Phase 2 sessions had no clear guidance on when/how to escalate issues, leading to wasted time on unresolvable problems (example: fintrack PR #9 spent 7+ commits on security scan false positives).

---

## Escalation Levels

### Level 1: Self-Resolve (< 30 minutes)
**When**: Minor issues you can fix quickly

**Examples**:
- Linting errors
- Formatting issues
- Simple test failures
- Documentation typos
- Missing imports

**Action**:
1. Attempt to fix locally
2. Verify fix works
3. Push to branch
4. Document in commit message

**Time Limit**: 30 minutes maximum

**If not resolved in 30 min**: Escalate to Level 2

---

### Level 2: Document & Continue (30-60 minutes)
**When**: Issue requires more investigation but doesn't block other work

**Examples**:
- Complex test failures (4+ tests)
- Build issues requiring dependency updates
- Performance problems
- Non-critical bugs discovered
- Design questions

**Action**:
1. Stop working on the issue after 30-60 minutes total effort
2. Create GitHub issue with details:
   ```markdown
   # [Type]: [Brief description]

   ## Problem
   [What's not working]

   ## What I Tried
   - Attempt 1: [description] - Result: [outcome]
   - Attempt 2: [description] - Result: [outcome]

   ## Context
   - Related PR: #[number]
   - Files involved: [list]
   - Error messages: [paste]

   ## Next Steps
   [Proposed solution or investigation needed]
   ```

3. Label issue appropriately: `needs-investigation`, `bug`, `enhancement`
4. Link issue in PR or manifest
5. Continue with other work

**Time Limit**: 60 minutes maximum total effort

**If blocks PR merge**: Escalate to Level 3

---

### Level 3: Session Blocker (> 60 minutes or blocks completion)
**When**: Issue prevents completing assigned work

**Examples**:
- Multiple PR CI failures after fixes
- Architectural problems discovered
- Breaking changes in dependencies
- Test infrastructure broken
- Required resources unavailable
- Security scan false positives (example: Phase 2 fintrack)

**Action**:
1. **Update manifest immediately**:
   ```markdown
   | repository | status | blocker |
   |------------|--------|---------|
   | repo-name  | blocked | Brief description + issue link |
   ```

2. **Create high-priority issue**:
   ```markdown
   # [BLOCKED] [Description]

   ## Blocker Details
   **Impact**: [What cannot be completed]
   **Severity**: [Critical / High / Medium]
   **Estimated resolution time**: [Unknown / Hours / Days]

   ## Problem
   [Detailed description]

   ## Investigation Done
   - [What was tried]
   - [Results]
   - [Time invested]: X hours

   ## Evidence
   - PR: #[number]
   - CI logs: [link]
   - Error messages: [paste]
   - Related issues: [links]

   ## Blocking
   - [ ] Task: [specific task blocked]
   - [ ] PR: #[number if applicable]
   - [ ] Session: [session ID]

   ## Request
   [What's needed to unblock]

   ## Workaround
   [Alternative if available, or "None"]
   ```

3. **Label**: `blocker`, `high-priority`

4. **Notify in manifest** with status update

5. **Move to alternative work**:
   - If multi-repo session: Work on different repository
   - If single task: Export session, create handoff document
   - Document current state for resumption

**Response Time**: Should be acknowledged within 24 hours

**If critical system issue**: Escalate to Level 4

---

### Level 4: Critical (Security / Data Loss / System Stability)
**When**: Issue affects security, data integrity, or system stability

**Examples**:
- Security vulnerabilities discovered
- Data loss potential
- System crashes or deadlocks
- Critical dependency vulnerabilities
- Production system impact
- Authentication/authorization bypasses

**Action**:
1. **STOP all related work immediately**

2. **Create critical issue**:
   ```markdown
   # 🚨 [CRITICAL] [Security/Stability Issue]

   ## Critical Details
   **Severity**: CRITICAL
   **Impact**: [Security / Data Loss / System Stability]
   **Affected**: [What systems/users are affected]
   **Exploit**: [Is there active exploitation? Known / Unknown / N/A]

   ## Problem
   [Clear, detailed description]

   ## Evidence
   [Code locations, error messages, security scan output]

   ## Immediate Risk
   [What could happen if not fixed immediately]

   ## Temporary Mitigation
   [Any immediate steps taken to reduce risk]

   ## Requires
   - [ ] Immediate review
   - [ ] Security team involvement (if applicable)
   - [ ] Emergency PR
   - [ ] System restart/rollback

   ## Related
   - Discovered in: [PR/commit/session]
   - Affects: [repositories/systems]
   ```

3. **Label**: `critical`, `security` (if applicable), `blocker`

4. **Update manifest** with "CRITICAL BLOCKER" status

5. **Halt related work**:
   - Do not create PRs that touch affected code
   - Do not merge related PRs
   - Document exactly what's unsafe

6. **Notify immediately** via manifest and issue

**Response Time**: Immediate (within hours)

**Example from Phase 2**:
- atari-style USB lockup bug was discovered and fixed
- System stability critical issue
- Correctly prioritized and resolved

---

## Decision Matrix

```
Can I fix this quickly?
├─ Yes, < 30 min → Level 1: Self-Resolve
└─ No → Continue evaluation

Does this block my current task?
├─ No → Level 2: Document & Continue
└─ Yes → Continue evaluation

Is this a security/stability issue?
├─ Yes → Level 4: Critical (STOP & ESCALATE)
└─ No → Level 3: Session Blocker

Have I spent > 60 minutes on this?
└─ Yes → Level 3 minimum (stop and escalate)
```

---

## Time Limits (Strict)

| Level | Time Limit | Action if Exceeded |
|-------|-----------|-------------------|
| Level 1 | 30 minutes | Escalate to Level 2 |
| Level 2 | 60 minutes total | Escalate to Level 3 if blocks work |
| Level 3 | No time limit | Move to other work, wait for resolution |
| Level 4 | IMMEDIATE | Halt all related work |

**Key Rule**: Do not spend unlimited time on any single issue. Escalate and move on.

---

## Phase 2 Examples

### Example 1: fintrack PR #9 (What NOT to Do)
**Issue**: Security scan false positive detecting credential REMOVAL as violation

**What Happened**:
- Attempt 1: Removed hardcoded credentials → flagged
- Attempt 2: Used environment variables → flagged
- Attempt 3: Used printf format strings → flagged
- Attempt 4: Shell variables → flagged
- Attempt 5: Fixed workflow to exclude deletions → workflow itself flagged
- Attempt 6: Excluded workflow files → still flagged
- Attempt 7: Excluded .md files → still flagged
- **Result**: 7+ commits, hours wasted, PR eventually closed

**What SHOULD Have Happened**:
- Attempt 1: Remove credentials → CI fails
- Attempt 2: Verify gosec passes (it did) → confirms false positive
- Attempt 3 (30 min mark): **ESCALATE to Level 3**
  - Create issue: "PR Validation security check has false positive"
  - Label: `blocker`, `workflow-bug`
  - Evidence: gosec passes, removing credentials is good
  - Request: Fix PR validation workflow
- Move to other work while check is fixed
- **Result**: Issue resolved in 1-2 hours, no wasted commits

**Lesson**: After 2-3 attempts to satisfy a broken check, ESCALATE. Don't persist.

### Example 2: atari-style USB Lockup (What TO Do)
**Issue**: System lockup when USB gamepad disconnected

**What Happened**:
- Issue discovered during systematic review
- Recognized as **Level 4: Critical** (system stability)
- Immediate priority given
- Fix implemented and tested
- PR merged quickly
- **Result**: Critical bug fixed, system stable

**Why This Worked**:
- Correctly identified as critical
- Given appropriate priority
- Not delayed or deprioritized
- Rapid resolution

**Lesson**: Critical issues deserve immediate attention and proper escalation.

### Example 3: Multiple PRs per Repo (What NOT to Do)
**Issue**: Initial PR had issues, new PRs created instead of fixing

**What Happened (fintrack)**:
- PR #4: Transaction management
- PR #5: Phase 2 improvements (different approach)
- PR #6: Formatting fixes (should have been in #5)
- PR #7: Category management (different feature)
- PR #8: errcheck fixes (should have been in #7)
- **Result**: 5 PRs, 2 closed, confusing history

**What SHOULD Have Happened**:
- PR #4: Transaction management
  - CI fails → Apply Level 1: Fix in place
  - If major issues → Apply Level 3: Close PR, create issue, rethink
  - **NOT**: Create PR #5 to fix #4
- Each feature gets ONE PR with fixes in place
- **Result**: Clean PR history, clear deliverables

**Lesson**: Fix PRs in place, don't create new PRs to fix old PRs.

---

## Escalation Response Times

| Level | Response Time | Who Responds | Action |
|-------|--------------|--------------|--------|
| Level 1 | Self-service | Session owner | Fix and continue |
| Level 2 | No response needed | Session owner | Document and continue |
| Level 3 | 24 hours | Project owner / Coordinator | Review and guide |
| Level 4 | Immediate (hours) | All stakeholders | Emergency response |

---

## Templates

### Level 2 Issue Template
```markdown
# [Bug/Investigation]: [Brief description]

## Problem
[What's not working or needs investigation]

## What I Tried
1. [Attempt 1] - Result: [outcome]
2. [Attempt 2] - Result: [outcome]
3. [Attempt 3] - Result: [outcome]

## Context
- Related PR: #[number if applicable]
- Files involved: [list]
- Error messages:
```
[paste errors]
```

## Hypothesis
[Why this might be happening]

## Next Steps
[Proposed investigation or solution]

## Time Invested
Approximately [X] hours (stopped at 60 min limit)
```

### Level 3 Blocker Issue Template
```markdown
# [BLOCKED] [Brief description]

## Blocker Details
**Impact**: Cannot complete [task/PR/session]
**Severity**: [Critical / High / Medium]
**Estimated resolution**: [Unknown / Hours / Days]

## Problem
[Detailed description of blocker]

## Investigation
Time invested: [X] hours

Attempts made:
1. [Attempt] - Result: [outcome]
2. [Attempt] - Result: [outcome]
3. [Attempt] - Result: [outcome]

## Evidence
- PR: #[number] ([link])
- CI logs: [link to failed run]
- Error messages:
```
[paste complete error]
```
- Related issues: [links if any]

## Currently Blocking
- [ ] PR: #[number] - [description]
- [ ] Task: [task name from roadmap]
- [ ] Session: [session ID]

## Request for Unblocking
[Specific action needed to resolve]

Options:
1. [Option 1] - [trade-offs]
2. [Option 2] - [trade-offs]

## Workaround
[Alternative approach if available, or "None available"]

## Current Status
- Manifest updated: [Yes/No]
- Alternative work: [What I'm working on instead]
- Session export: [Link to my-context export if applicable]
```

### Level 4 Critical Issue Template
```markdown
# 🚨 [CRITICAL] [Security/Stability Issue]

## CRITICAL DETAILS
**Severity**: CRITICAL
**Type**: [Security Vulnerability / Data Loss Risk / System Crash / Other]
**Impact**: [Who/what is affected]
**Active Exploit**: [Yes/No/Unknown]
**Discovered**: [Date/Time]

## PROBLEM DESCRIPTION
[Clear, detailed explanation of the critical issue]

## SECURITY/STABILITY IMPACT
[Exactly what could go wrong]

Potential consequences:
- [Consequence 1]
- [Consequence 2]

## EVIDENCE
Location in code: [file:line]

Error/Vulnerability:
```
[paste evidence - error logs, security scan output, etc.]
```

## IMMEDIATE RISK ASSESSMENT
- **Likelihood**: [High / Medium / Low]
- **Impact if exploited**: [Severe / Major / Moderate]
- **Exploitability**: [Easy / Moderate / Difficult]

## TEMPORARY MITIGATION
Actions taken to reduce immediate risk:
- [Action 1]
- [Action 2]

## REQUIRES
- [ ] Immediate review by [role]
- [ ] Security assessment
- [ ] Emergency PR
- [ ] System restart/rollback
- [ ] User notification

## DISCOVERED IN
- PR: #[number]
- Commit: [hash]
- Session: [session ID]
- File(s): [list]

## HALTED WORK
The following work has been stopped:
- [Related PR or task 1]
- [Related PR or task 2]

Do NOT merge or continue work on affected code until resolved.
```

---

## Integration with Phase 3

**For Phase 3**, escalation is **MANDATORY**:

1. **Session prompts must include**:
   - Link to escalation protocol
   - Time limits for each level
   - Decision matrix quick reference

2. **Manifest must track**:
   - Escalation level for blocked tasks
   - Issue links for all escalations
   - Current status of blocker resolution

3. **Quality gates must enforce**:
   - No session can spend >60 min on single issue without escalating
   - No PR can be in "fixing" status for >3 iterations
   - All Level 3+ escalations must be in manifest

4. **Success metrics**:
   - < 10% of tasks reach Level 3
   - Zero instances of >2 hours spent before escalating
   - All Level 4 issues resolved within 24 hours

---

## Key Principles

### Principle 1: Time is Precious
**Don't waste hours on issues that should be escalated**

Phase 2 Lesson: fintrack spent 7+ commits (hours) on a broken check. Should have escalated after 30-60 minutes.

### Principle 2: Escalation is Not Failure
**Escalating is good engineering judgment**

Knowing when to ask for help is a skill. Don't view escalation as giving up.

### Principle 3: Move Forward
**Don't let one issue block everything**

If Task A is blocked, work on Task B. Parallel progress > single-threaded stuck.

### Principle 4: Document Everything
**Future you (or others) will thank you**

Good escalation issues make it easy to resume work later with full context.

---

**Version**: 1.0
**Created**: 2025-11-23
**Author**: Phase 2 retrospective learnings
**Status**: Active for Phase 3 and beyond
