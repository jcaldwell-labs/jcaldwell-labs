# Parallel Session Manifest

**Phase**: 2 - Repository Improvements
**Started**: Not yet started
**Status**: Ready to launch

---

## Session Status

| Repository | Status | Session ID | Started | Completed | PR | Report | Blocker |
|-----------|--------|-----------|---------|-----------|----|----|---------|
| fintrack | not_started | - | - | - | - | - | - |
| boxes-live | completed | phase2-boxes-live | 2025-11-22 | 2025-11-22 | #11 | reports/BOXES-LIVE-IMPROVEMENT-REPORT.md | - |
| terminal-stars | not_started | - | - | - | - | - | - |
| my-context | not_started | - | - | - | - | - | - |
| tario | not_started | - | - | - | - | - | - |
| adventure-engine-v2 | not_started | - | - | - | - | - | - |
| smartterm-prototype | not_started | - | - | - | - | - | - |
| atari-style | not_started | - | - | - | - | - | - |
| .github | not_started | - | - | - | - | - | - |

---

## Status Definitions

- **not_started**: No session claimed yet
- **in_progress**: Session actively working
- **completed**: Session finished, PR submitted
- **needs_handoff**: Work paused, needs transfer to another session
- **blocked**: Issue preventing completion (use ESCALATION-PROTOCOL.md)
- **escalated**: Critical blocker, needs owner intervention (Level 3/4)

---

## Instructions for Sessions

When starting work on a repository:

1. **Claim the repository**:
   - Change status to `in_progress`
   - Add your session ID (e.g., `session-A`, `session-B`, etc.)
   - Add start date (YYYY-MM-DD)
   - Commit and push this file

2. **Do your work**:
   - Follow the standard checklist in ROADMAP-2025.md
   - Complete repository-specific tasks
   - Create PR with improvements
   - Write improvement report

3. **Mark complete**:
   - Change status to `completed`
   - Add completion date
   - Add PR number (e.g., `#42`)
   - Add report path (e.g., `reports/REPO-REPORT.md`)
   - Commit and push this file

4. **If blocked**:
   - Change status to `blocked`
   - Add blocker description
   - Follow ESCALATION-PROTOCOL.md (Level 1-2)
   - Create GitHub issue if needed
   - Commit and push this file

5. **If needs handoff**:
   - Change status to `needs_handoff`
   - Create handoff document in `sessions/` (use SESSION-HANDOFF-PROTOCOL.md)
   - Document current state, decisions, next steps
   - Commit and push both files

6. **If escalated**:
   - Change status to `escalated`
   - Critical blocker encountered (Level 3-4 in ESCALATION-PROTOCOL.md)
   - Document in blocker column
   - Owner intervention required
   - Commit and push this file

---

## Progress Summary

**Last Updated**: 2025-11-23

- Completed: 1 / 9
- In Progress: 0 / 9
- Not Started: 8 / 9
- Needs Handoff: 0 / 9
- Blocked: 0 / 9
- Escalated: 0 / 9

---

## Notes

- Each session should work on one repository independently
- Update this manifest when starting, completing, or encountering blockers
- Coordinate via git commits to avoid conflicts
- See PARALLEL-SESSION-GUIDE.md for detailed instructions

---

**Manifest Version**: 1.0
**Created**: 2025-11-22
