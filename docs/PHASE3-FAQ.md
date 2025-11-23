# Phase 3 Frequently Asked Questions

**Created**: 2025-11-23
**Purpose**: Answer common questions about revised Phase 3 approach

---

## General Questions

### Q: How is Phase 3 different from the original plan?

**A**: Significantly restructured based on Phase 2 lessons:

**Original Plan**:
- Single coordinating session
- 1-2 weeks duration
- ~5 comprehensive PRs
- Vague success criteria

**Revised Plan**:
- 4 sub-phases (3a/b/c/d) with 7 total sessions
- 4-5 weeks duration (realistic)
- ~24 incremental PRs (avg 95 lines each)
- Specific measurable success criteria
- 7 new structural protocols

**Why**: Phase 2 proved parallel execution works but exposed gaps in handling PR failures, scope control, and completion criteria.

---

### Q: Why 4-5 weeks instead of 1-2 weeks?

**A**: **Realistic time estimates** that account for fix cycles:

**Phase 2 Lesson**:
- Estimated: 40-50 hours
- Actual: 80 hours (+60%)
- **Why**: Didn't account for CI fixes, review feedback, multiple PR iterations

**Phase 3 Approach**:
- Base estimate: ~100 hours of work
- + 50% buffer for CI fix cycles: +50 hours
- + Documentation overhead: +8 hours
- = ~158 hours total
- At 40 hours/week = 4 weeks minimum

**Additional factors**:
- Sequential dependencies (Phase 3a must finish before 3b)
- Review/approval cycles
- Human decision points
- Buffer for unexpected issues

**Better to estimate realistically and finish early than estimate optimistically and run over.**

---

### Q: Why 24 small PRs instead of 5-10 large PRs?

**A**: **Incremental merge strategy** reduces risk and accelerates delivery:

**Benefits of small PRs** (from INCREMENTAL-MERGE-STRATEGY.md):
1. **Faster reviews**: Reviewer can approve 200-line PR in 15 min vs 2 hours for 2,000-line PR
2. **Lower failure risk**: Small PR easier to validate locally
3. **Easier debugging**: If CI fails, smaller blast radius
4. **Partial success**: Can merge 80% even if 20% blocked
5. **Continuous integration**: Work lands incrementally, not all at once

**Phase 2 Evidence**:
- boxes-live PR #13: +3,472 lines, hard to review
- fintrack incremental PRs #6, #7, #8: All merged successfully
- **Small PRs merged faster**

**Target**: 100-300 lines per PR (sweet spot for reviewability)

---

### Q: What happens if a PR fails CI in Phase 3?

**A**: **Follow PR-FAILURE-PROTOCOL.md decision tree**:

```
PR fails CI
├─ Formatting/linting? → FIX IN PLACE (push to same branch)
├─ 1-3 test failures? → FIX IN PLACE
├─ 4+ test failures? → EVALUATE (fix or close within 30 min)
├─ Security false positive? → ESCALATE (don't waste time)
└─ Real security issue? → FIX IMMEDIATELY
```

**Key Rules**:
1. **Fix in place**: Push fixes to same PR branch (don't create new PR)
2. **Three-strike rule**: After 3 fix iterations, escalate or close
3. **Time-box**: Don't spend > 2 hours total on fixes
4. **Escalate**: Level 3 if stuck, Level 4 if critical

**What we learned from Phase 2**:
- fintrack created 4 PRs when should have been 1 (no fix-in-place protocol)
- fintrack PR #9 spent 7+ commits on false positive (should have escalated earlier)

**Phase 3 difference**: Clear protocol exists, sessions must follow it.

---

### Q: How do sessions coordinate in Phase 3?

**A**: **Hybrid model** depending on sub-phase:

**Phase 3a (Sequential)**:
- Single session creates all 9 PRs
- One PR at a time
- Each PR must merge before next starts
- No coordination needed (one session)

**Phase 3b (Parallel - 3 sessions)**:
- Each session works independently
- Minimal dependencies between sessions
- Coordinate via manifest updates only
- Sessions can run simultaneously

**Phase 3c (Sequential)**:
- Single session for org-wide changes
- One PR at a time
- Careful testing before each merge

**Phase 3d (Parallel - 2 sessions)**:
- Independent documentation work
- Can run simultaneously
- Cross-reference each other's work

**Coordination mechanism**:
- GitHub manifest file (update status)
- GitHub issues (for blockers/questions)
- my-context exports (document decisions)

---

### Q: What if a session can't complete its work?

**A**: **Follow SESSION-HANDOFF-PROTOCOL.md**:

1. **Document current state**:
   - What's complete
   - What's in progress
   - What's not started
   - Any blockers

2. **Create handoff document**:
   - HANDOFF-STATE.md in repository
   - Commands to resume
   - Environment setup notes

3. **Update tracking**:
   - Manifest: status = "needs_handoff"
   - GitHub issue with handoff details
   - my-context export

4. **Clean up**:
   - Push all work
   - No local-only state
   - Verify branch is usable

**Resuming session** reads handoff docs and continues where left off.

**Time budget management**: Sessions have ~40h budgets with built-in buffers. If hitting budget, prepare handoff at ~35h mark.

---

### Q: How is "done" defined for Phase 3 tasks?

**A**: **"Done done" from DONE-DEFINITION.md**:

A task is done when **ALL** of these are true:
1. ✓ Code complete and committed
2. ✓ Local validation passed (pre-pr-check.sh)
3. ✓ PR created
4. ✓ CI passing (all green checkmarks)
5. ✓ Review addressed
6. ✓ Improvement report written
7. ✓ my-context exported
8. ✓ Manifest updated
9. ✓ Ready to merge

**NOT done**:
- ❌ PR created but CI failing
- ❌ PR passing but no report
- ❌ Work local but not pushed
- ❌ "Almost done" (either done or not done)

**Phase 2 mistake**: Considered work "done" when PR created, leading to 60% time overruns for fix cycles.

**Phase 3 fix**: Don't mark complete until truly "done done".

---

### Q: Why are improvement reports mandatory now?

**A**: **Phase 2 had only 1/8 reports**, making rollup analysis difficult:

**Problems without reports**:
- Hard to assess what was actually done
- Lessons learned not captured
- Metrics not collected
- Difficult to create phase summary

**Phase 3 solution**:
- Reports are **mandatory deliverable**
- Auto-generation script reduces manual work (generate-improvement-report.sh)
- Template provides structure
- "Done done" includes report completion

**What's in report**:
- Checklist completion status
- What was done
- What was found (issues, tech debt)
- Metrics (before/after)
- Recommendations
- Time invested

**Reports enable**: Better rollup, clearer outcomes, captured learnings

---

### Q: What's the "three-strike rule"?

**A**: **Stop after 3 PR fix iterations** (from PR-FAILURE-PROTOCOL.md):

```
Iteration 1: Fix obvious issues, push
├─ CI passes? → Done, move on
└─ CI fails → Continue

Iteration 2: Fix less obvious issues, push
├─ CI passes? → Done, move on
└─ CI fails → Continue

Iteration 3: Fix remaining issues, push
├─ CI passes? → Done, move on
└─ CI fails → STOP

After 3 iterations:
→ Something is fundamentally wrong
→ Escalate to Level 3 or close PR
→ Rethink approach
```

**Why 3?**:
- Iteration 1 catches simple errors
- Iteration 2 catches complex errors
- Iteration 3 is already a warning sign
- Beyond 3 = architectural problem, not implementation error

**Phase 2 example**:
- fintrack PR #9: 7+ iterations (should have stopped at iteration 3)
- Result: Wasted time, PR eventually closed

**Phase 3 enforcement**: Protocol mandates escalation or closure after iteration 3.

---

### Q: Can tasks be completed faster than estimated?

**A**: **Yes, and that's great!**

**Estimates include buffers**:
- Base time: Actual coding/writing
- +50% buffer: CI fix cycles
- +25% buffer: Review feedback
- +20% buffer: Documentation

**If you complete faster**:
- CI passes first try → Save fix cycle buffer time
- No review issues → Save review buffer time
- Quick documentation → Save doc buffer time

**Faster completion is success**, not failure!

**Examples**:
- Simple PR with great local validation → No CI fixes needed → Done in base time
- Well-documented change → No review feedback → Done quickly

**Buffers are insurance, not guarantees of delay.**

---

### Q: What if I discover additional work during Phase 3?

**A**: **Strict scope control** (from INCREMENTAL-MERGE-STRATEGY.md):

**In Scope** (do it):
- Items on task breakdown for your PR
- Bug fixes discovered while working on in-scope items
- Critical security fixes (escalate to Level 4 first)

**Out of Scope** (create issue, don't implement):
- Features not on task breakdown
- "While I'm here" improvements
- Refactorings beyond current PR scope
- Nice-to-have enhancements
- Experimental ideas

**Process for out-of-scope work**:
1. Create GitHub issue documenting idea
2. Label appropriately: `enhancement`, `future-work`
3. Continue with in-scope work
4. **Do not implement** out-of-scope items

**Why strict?**:
- Prevents scope creep
- Keeps PRs focused and reviewable
- Maintains timeline predictability
- Reduces risk

**Exception**: Critical security or stability issues (atari-style USB bug example)

---

### Q: How do I know if I should escalate?

**A**: **Use ESCALATION-PROTOCOL.md decision matrix**:

**Escalate to Level 1** (self-resolve):
- Issue seems fixable in < 30 min
- You know what to do
- Low risk

**Escalate to Level 2** (document & continue):
- Issue needs 30-60 min investigation
- Doesn't block other work
- Can work around it

**Escalate to Level 3** (session blocker):
- Issue prevents completing your work
- Spent > 60 min already
- No clear solution
- Blocks PR merge

**Escalate to Level 4** (critical):
- Security vulnerability
- Data loss risk
- System stability issue
- Production impact

**When in doubt**: Escalate earlier rather than later. Better to escalate Level 2 and resolve quickly than grind on Level 3 blocker for hours.

---

### Q: What's different about Phase 3 vs Phase 2 session prompts?

**A**: **Phase 3 prompts are much more structured**:

**Phase 2 prompts had**:
- Task list
- General guidance
- Deliverable expectations

**Phase 3 prompts have**:
- Exact PR breakdown (PR 1: this, PR 2: that)
- Mandatory protocol references
- Specific success criteria per PR
- Time estimates with buffers
- Critical rules section
- "Done done" checklist
- Examples of what NOT to do (from Phase 2)

**Why**:
Phase 2 taught us that sessions need **very explicit guidance** on:
- When to create PRs
- How many PRs to create
- What to do when PR fails
- When to stop and escalate

**Phase 3 sessions have clear guardrails.**

---

### Q: Can Phase 3 sub-phases be reordered?

**A**: **Some flexibility, but dependencies exist**:

**Must be sequential**:
- Phase 3a before 3b (build system needed for integration work)
- Phase 3c should be after 3a (org changes need stable base)

**Can be parallel**:
- Phase 3b and 3d can overlap (documentation doesn't depend on integrations)
- Within 3b, all 3 sessions are independent

**Recommended order**:
1. Phase 3a (foundation)
2. Phase 3b & 3d parallel (max parallel execution)
3. Phase 3c (org standardization benefits from stable state)

**Do NOT**:
- Start 3b before 3a complete
- Start integration work without build system
- Apply org changes before individual projects stable

---

### Q: What if Phase 3 reveals more structural gaps?

**A**: **Adaptive approach**:

1. **Identify gap** during execution
2. **Document gap** in session notes
3. **Create issue** for gap closure
4. **Assess impact**:
   - Can Phase 3 continue? → Continue, fix gap in parallel
   - Does gap block Phase 3? → Pause, fix gap, resume

5. **Create artifact** to close gap
6. **Update protocols**
7. **Apply to ongoing work**

**Continuous improvement**: Protocols aren't perfect, they evolve.

**Phase 2 experience**: We identified 7 structural gaps and created artifacts to close them before Phase 3.

**Phase 3 may reveal**: Additional gaps we didn't anticipate. That's okay. Document and address them.

---

### Q: How do we measure Phase 3 success?

**A**: **Specific metrics** (from revised ROADMAP-2025.md):

**Quantitative**:
- 24 PRs created (target)
- > 90% PR merge rate
- < 2 avg CI fix iterations per PR
- < 20% CI failure rate
- ~158 hours total time (within 20%)
- 4-5 weeks calendar time

**Qualitative**:
- Unified build system works (`make build-all`, `make test-all`)
- Integration examples are executable
- Organization standardized
- Community docs comprehensive

**Process quality**:
- Zero multi-PR situations (like Phase 2 fintrack)
- All sessions follow protocols
- All improvement reports completed
- All escalations handled appropriately

**Ultimate success**: Better process than Phase 2, cleaner execution, predictable outcomes.

---

### Q: What's the biggest risk in Phase 3?

**A**: **Cross-repository dependencies** (new in Phase 3):

**Phase 2**: Each session worked on one repo independently
**Phase 3**: Work spans multiple repos (build system affects all, integrations cross repos)

**Risks**:
- Change in one repo breaks another
- Dependencies create blocking chains
- Coordination overhead increases

**Mitigations**:
1. **Incremental PRs**: Small changes, easier to verify cross-repo impact
2. **Test thoroughly**: Every PR must validate no regressions
3. **Sequential where needed**: Phase 3a is sequential to manage dependencies
4. **Clear interfaces**: Integration points well-defined before coding
5. **Rollback plans**: Document how to undo changes

**This is why Phase 3 is more complex** than Phase 2 and needs better structure.

---

### Q: Can I start Phase 3 if some Phase 2 work is incomplete?

**A**: **Depends on what's incomplete**:

**Current Phase 2 status**: 8/9 complete (fintrack partial)

**Can proceed if**:
- Core infrastructure complete (CI/CD, docs, tests) → YES
- Only edge features incomplete → YES
- All critical bugs fixed → YES

**Should NOT proceed if**:
- Critical bugs unfixed → NO
- Infrastructure missing → NO
- Multiple repos incomplete → NO

**Current assessment**: **YES, can proceed**
- fintrack has PRs #6, #7, #8 merged (substantial improvements)
- Only PR #9 (usage testing) incomplete - not blocking
- All 8 other repos complete
- Critical bugs fixed (atari-style USB lockup)

**Recommendation**: Mark Phase 2 as 89% complete, proceed to Phase 3.

---

### Q: What if Phase 3 takes longer than 5 weeks?

**A**: **Acceptable with proper communication**:

**5 weeks is realistic estimate**, not hard deadline.

**If running longer**:
1. **Assess why**: What's causing delays?
   - More fix cycles than expected? → Normal, buffer was estimate
   - Scope creep? → Enforce scope controls
   - Unexpected complexity? → Re-estimate remaining work

2. **Update estimates**: If at week 3 and only 40% done, revise total to 7-8 weeks

3. **Communicate**: Keep owner informed of progress

4. **Maintain quality**: Don't rush to hit timeline if it means sacrificing quality

**Better to deliver high-quality work in 6 weeks than rushed work in 4 weeks.**

**Hard deadline**: None. This is self-directed improvement project, not customer delivery.

---

### Q: Why hybrid parallel/sequential instead of all parallel?

**A**: **Dependencies require sequencing**:

**Must be sequential** (can't parallelize):
- **Phase 3a**: Each PR depends on previous (build-all needs build-c-all and build-go-all)
- **Phase 3c**: Org changes affect all repos (must be careful and sequential)

**Can be parallel** (independent work):
- **Phase 3b**: Each integration example independent (my-context, terminal UI, workflows)
- **Phase 3d**: Documentation work independent (getting started, comparison)

**Why not all parallel?**:
- Parallel work requires independence
- Cross-repo dependencies create blocking
- Some work inherently sequential (foundation before building)

**Hybrid is optimal**: Parallel where possible, sequential where necessary.

---

### Q: What protocols are most important to follow?

**A**: **Priority order**:

**Critical (Must follow)**:
1. **PR-FAILURE-PROTOCOL.md**: Prevents multi-PR chaos
2. **Pre-pr-check.sh**: Prevents CI failures
3. **DONE-DEFINITION.md**: Ensures actual completion

**Important (Should follow)**:
4. **ESCALATION-PROTOCOL.md**: Prevents wasted time on blockers
5. **INCREMENTAL-MERGE-STRATEGY.md**: Guides task breakdown

**Useful (Reference as needed)**:
6. **SESSION-HANDOFF-PROTOCOL.md**: When work spans sessions
7. **generate-improvement-report.sh**: Automates report creation

**If time limited**: Read #1-3 minimum. Others as needed.

---

### Q: How do we avoid repeating Phase 2's problems?

**A**: **Structured approach addresses each Phase 2 issue**:

| Phase 2 Problem | Phase 3 Solution |
|-----------------|------------------|
| Multiple PRs per repo | PR-FAILURE-PROTOCOL: fix in place |
| No pre-PR validation | pre-pr-check.sh mandatory |
| Vague "done" definition | DONE-DEFINITION explicit criteria |
| 60% time overrun | Realistic estimates with buffers |
| Large PRs hard to review | INCREMENTAL-MERGE-STRATEGY: small PRs |
| Missing improvement reports | Reports mandatory, auto-generated |
| No escalation guidance | ESCALATION-PROTOCOL with 4 levels |
| Scope creep | Strict in-scope vs out-of-scope rules |

**The difference**: Phase 2 had good ideas but no structure for when things went wrong.
**Phase 3 has**: Protocols for every common problem we encountered.

**Key**: Sessions must **actually follow** the protocols.

---

### Q: What's the rollback plan if Phase 3 fails?

**A**: **Incremental PRs enable easy rollback**:

**Rollback individual PR**:
```bash
# Revert single merged PR
git revert <commit-hash>
git push

# Small PR → small revert, low risk
```

**Rollback entire sub-phase**:
```bash
# Revert all PRs from Phase 3a
git revert <pr9-commit>..<pr1-commit>

# Or individually
git revert <pr9-commit>
git revert <pr8-commit>
[etc.]
```

**Benefits of incremental approach**:
- Can rollback one PR without losing others
- Easier to identify which PR caused issue
- Lower risk per rollback

**Prevention better than rollback**:
- Pre-PR validation reduces issues
- Small PRs easier to verify
- Each PR tested independently

---

### Q: When does Phase 4 start?

**A**: **After Phase 3 completely done**:

**Phase 3 complete means**:
- All 4 sub-phases complete (3a, 3b, 3c, 3d)
- All ~24 PRs merged
- All exit gate criteria met
- Phase 3 summary report created
- Human sign-off received

**Then**: Proceed to Phase 4 (Continuous Audit)

**Do NOT start Phase 4**:
- While Phase 3 work incomplete
- If critical blockers exist
- Before exit gates validated

**Estimated**: Phase 4 start date is ~5 weeks from Phase 3 launch (if launched now)

---

### Q: Can I suggest improvements to the protocols?

**A**: **Yes, please!**

**Process**:
1. Create GitHub issue in jcaldwell-labs/jcaldwell-labs
2. Title: `[Protocol Improvement] [Protocol name]`
3. Describe:
   - What's unclear or insufficient
   - Proposed improvement
   - Why it would help

4. Label: `documentation`, `process`

5. Discuss and iterate

6. Update protocol when approved

**Protocols are living documents**: They should improve based on usage and feedback.

**Phase 3 will reveal**: What works, what doesn't, what's missing.

**Be adaptive**: Update protocols as we learn.

---

**FAQ Version**: 1.0
**Created**: 2025-11-23
**Last Updated**: 2025-11-23
**Status**: Active for Phase 3
**More questions?**: Create issue in jcaldwell-labs/jcaldwell-labs
