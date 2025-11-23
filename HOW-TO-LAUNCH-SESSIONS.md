# How to Launch Phase 2 Parallel Sessions

**Quick Guide**: Copy and paste the launcher text below into each Claude Code session.

---

## Prerequisites

Before launching ANY sessions:

1. ✅ Phase 1 complete (PRs merged, repos synced, system rebooted)
2. ✅ PARALLEL-SESSION-MANIFEST.md created and committed
3. ✅ All prompt files pushed to GitHub (this repo)

---

## Launch Instructions

For each session below:

1. **Navigate to the repository** (or open Claude Code in that repository)
2. **Copy the launcher text** for that session
3. **Paste it as your first message** to Claude Code
4. **Let the session run autonomously**

---

## Session A: fintrack

**Repository**: https://github.com/jcaldwell-labs/fintrack

**Copy and paste this:**

```
Please read and execute the instructions in this file:

https://raw.githubusercontent.com/jcaldwell-labs/jcaldwell-labs/master/SESSION-A-FINTRACK-PROMPT.txt

This is your Phase 2 improvement assignment for the fintrack repository.
```

---

## Session B: boxes-live

**Repository**: https://github.com/jcaldwell-labs/boxes-live

**Copy and paste this:**

```
Please read and execute the instructions in this file:

https://raw.githubusercontent.com/jcaldwell-labs/jcaldwell-labs/master/SESSION-B-BOXES-LIVE-PROMPT.txt

This is your Phase 2 improvement assignment for the boxes-live repository.
```

---

## Session C: terminal-stars

**Repository**: https://github.com/jcaldwell-labs/terminal-stars

**Copy and paste this:**

```
Please read and execute the instructions in this file:

https://raw.githubusercontent.com/jcaldwell-labs/jcaldwell-labs/master/SESSION-C-TERMINAL-STARS-PROMPT.txt

This is your Phase 2 improvement assignment for the terminal-stars repository.
```

---

## Session D: my-context

**Repository**: https://github.com/jcaldwell-labs/my-context

**Copy and paste this:**

```
Please read and execute the instructions in this file:

https://raw.githubusercontent.com/jcaldwell-labs/jcaldwell-labs/master/SESSION-D-MY-CONTEXT-PROMPT.txt

This is your Phase 2 improvement assignment for the my-context repository.
```

---

## Session E: tario

**Repository**: https://github.com/jcaldwell-labs/tario

**Copy and paste this:**

```
Please read and execute the instructions in this file:

https://raw.githubusercontent.com/jcaldwell-labs/jcaldwell-labs/master/SESSION-E-TARIO-PROMPT.txt

This is your Phase 2 improvement assignment for the tario repository.
```

---

## Session F: adventure-engine-v2

**Repository**: https://github.com/jcaldwell-labs/adventure-engine-v2

**Copy and paste this:**

```
Please read and execute the instructions in this file:

https://raw.githubusercontent.com/jcaldwell-labs/jcaldwell-labs/master/SESSION-F-ADVENTURE-ENGINE-V2-PROMPT.txt

This is your Phase 2 improvement assignment for the adventure-engine-v2 repository.
```

---

## Session G: Combined (smartterm-prototype, atari-style, .github)

**Repository**: Start with https://github.com/jcaldwell-labs/smartterm-prototype

**Copy and paste this:**

```
Please read and execute the instructions in this file:

https://raw.githubusercontent.com/jcaldwell-labs/jcaldwell-labs/master/SESSION-G-COMBINED-REPOS-PROMPT.txt

This is your Phase 2 improvement assignment for smartterm-prototype, atari-style, and .github repositories.

IMPORTANT: This session handles THREE repositories. The atari-style repository includes a CRITICAL USB fix that must be applied.
```

---

## Monitoring Progress

After launching all sessions, monitor progress via:

```bash
# Clone coordination repo if you haven't
git clone https://github.com/jcaldwell-labs/jcaldwell-labs.git ~/jcaldwell-labs-coordination

# Check manifest periodically
cd ~/jcaldwell-labs-coordination
git pull
cat PARALLEL-SESSION-MANIFEST.md
```

Watch for:
- Status changes from "not_started" → "in_progress" → "completed"
- Blocker notifications
- PR links appearing

---

## What Happens Next

Each session will:

1. **Claim its repository** (update manifest)
2. **Work through its checklist** autonomously
3. **Create a PR** with improvements
4. **Write an improvement report**
5. **Export its my-context session**
6. **Mark itself complete** in the manifest

When all 7 sessions complete, you'll have:
- 9 improved repositories (Session G handles 3)
- 9 pull requests
- 9 improvement reports
- 7 context exports
- Complete manifest showing all work done

---

## Timeline

**Expected completion**: 1-2 weeks with all sessions running in parallel

Individual session durations:
- Session A (fintrack): 6-8 hours
- Session B (boxes-live): 6-8 hours
- Session C (terminal-stars): 4-6 hours
- Session D (my-context): 6-8 hours
- Session E (tario): 4-6 hours
- Session F (adventure-engine-v2): 4-6 hours
- Session G (combined): 6-10 hours

---

## After All Sessions Complete

1. Pull coordination repo to get all reports and session exports
2. Review all improvement reports
3. Review all PRs
4. Run validation script (if created)
5. Generate Phase 2 summary
6. Sign off on Phase 2 completion
7. Proceed to Phase 3

---

## Questions?

Create an issue in the jcaldwell-labs coordination repository.

---

**Last Updated**: 2025-11-22
**Status**: Ready to launch
