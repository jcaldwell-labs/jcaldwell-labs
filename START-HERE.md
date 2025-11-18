# JCaldwell Labs - START HERE 👋

**Welcome!** This workspace coordinates the jcaldwell-labs GitHub organization.

---

## 🎯 What is This?

This is a **coordination workspace** for managing 8 Unix philosophy-inspired terminal projects. Think of it as mission control for jcaldwell-labs.

---

## 🚀 Quick Start (Pick Your Path)

### Path 1: Visual Exploration (Recommended First Time)
**See the big picture in boxes-live**

```bash
cd ~/projects/boxes-live
boxes-live
# Press F3, type: ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt
```

Then read: **[VIEW-IN-BOXES-LIVE.md](./VIEW-IN-BOXES-LIVE.md)**

---

### Path 2: Text Overview (Fast Reference)
**Read the executive summary**

```bash
cat ~/projects/jcaldwell-labs/README.md
```

Key sections:
- Projects overview (7 projects + org profile)
- Current status (4 open PRs)
- Vision (Unix alternatives to enterprise tools)
- Next actions (prioritized)

---

### Path 3: Detailed Status (For Deep Dive)
**Get complete project health**

```bash
cat ~/projects/jcaldwell-labs/DASHBOARD.md
```

Includes:
- Full PR analysis with review prompts
- Per-project deep dives
- Health metrics
- Coordination checklists

---

### Path 4: Take Action (For Developers)
**Pick a feature and start coding**

```bash
cat ~/projects/jcaldwell-labs/NEXT-STEPS.md
```

Contains:
- 18+ ready-to-use prompts
- Organized in 3 waves (high → medium → low priority)
- Parallel work opportunities
- Detailed follow-up prompts per project

---

### Path 5: AI Agent Session
**If you're Claude Code starting a new session**

```bash
cat ~/projects/jcaldwell-labs/CLAUDE.md
```

Complete guidance on:
- Architecture and principles
- Common commands
- Context management (db:jcaldwell_labs partition)
- Workflow guidelines

---

## 📚 All Documents

| File | Size | When to Read | Purpose |
|------|------|--------------|---------|
| **START-HERE.md** | - | First time | You are here - navigation guide |
| **[README.md](./README.md)** | 5.5K | Daily | Strategic overview, quick reference |
| **[DASHBOARD.md](./DASHBOARD.md)** | 17K | Daily | Live status, PR reviews, health metrics |
| **[NEXT-STEPS.md](./NEXT-STEPS.md)** | 18K | When planning work | Ready prompts, parallel opportunities |
| **[CLAUDE.md](./CLAUDE.md)** | 7.8K | AI session start | Complete agent guidance |
| **[AUDIT-COMPLETE.md](./AUDIT-COMPLETE.md)** | 11K | For context | Audit summary, deliverables, metrics |
| **[VIEW-IN-BOXES-LIVE.md](./VIEW-IN-BOXES-LIVE.md)** | 9.9K | Visual exploration | How to use boxes-live canvas |
| **jcaldwell-labs-canvas.txt** | 4.1K | N/A (data file) | Load in boxes-live (F3) |

**Total Documentation:** ~75K words of comprehensive guidance

---

## 🎨 Two Ways to Explore

### Visual (boxes-live)
- **Best for:** Big picture understanding, spatial relationships
- **How:** Load `jcaldwell-labs-canvas.txt` in boxes-live
- **Shows:** 16 color-coded boxes with project status
- **Navigation:** Pan/zoom around 2D canvas

### Text (Markdown)
- **Best for:** Detailed reading, copy-paste, searching
- **How:** Read .md files in any editor
- **Shows:** Complete details, formatted text
- **Navigation:** Linear, top-to-bottom

**Use both!** Visual for overview, text for details.

---

## 🗂️ File Organization

```
~/projects/jcaldwell-labs/
├── START-HERE.md              ← You are here
├── README.md                  ← Daily quick reference
├── DASHBOARD.md               ← Live project status
├── NEXT-STEPS.md              ← Work opportunities
├── CLAUDE.md                  ← AI agent guide
├── AUDIT-COMPLETE.md          ← Audit summary
├── VIEW-IN-BOXES-LIVE.md      ← Visual guide
├── jcaldwell-labs-canvas.txt  ← boxes-live canvas
└── jcaldwell-labs-audit-2025-11-18.md  ← Session export
```

---

## 🎯 Common Questions

### "I want to work on a feature. Where do I start?"

1. **Check DASHBOARD.md** for project status
2. **Read NEXT-STEPS.md** for ready prompts
3. **Pick a feature** from Wave 1 (high value)
4. **Clone the repo** and start coding
5. **Track work** in my-context partition

Example:
```bash
# Pick fintrack transactions from NEXT-STEPS.md
gh repo clone jcaldwell-labs/fintrack
cd fintrack
export MY_CONTEXT_HOME=db:fintrack_dev
my-context start "feature-transactions-2025-11-18"
# Copy prompt from NEXT-STEPS.md and execute
```

---

### "I want to review a PR. Where are they?"

**DASHBOARD.md** has all 4 open PRs with:
- Full descriptions
- Review instructions
- Ready-to-use review prompts

Or check quickly:
```bash
/tmp/check-prs.sh  # Script created during audit
```

---

### "I'm starting a new AI agent session. What do I read?"

**CLAUDE.md** has everything you need:
- Architecture principles
- Common commands
- Context management patterns
- Workflow guidelines

Then:
```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "task-$(date +%Y-%m-%d)"
```

---

### "How do I see this visually?"

**VIEW-IN-BOXES-LIVE.md** has complete instructions.

TL;DR:
```bash
cd ~/projects/boxes-live
boxes-live
# Press F3
# Type: ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt
# Navigate with arrow keys
```

---

### "What's the current status?"

**Quick Status (as of 2025-11-18):**
- ✅ 8 projects, all active
- 🟡 4 open PRs needing review
- 🟢 18+ features ready for parallel development
- 🔴 0 GitHub stars (new org, need promotion)

Details in **DASHBOARD.md**

---

### "What should I work on next?"

**Priority order:**
1. Review 4 open PRs (today)
2. Implement 3 high-value features (this week)
3. Complete CLAUDE.md for all projects (ongoing)

Full plan in **NEXT-STEPS.md**

---

## 🧭 Navigation Flowchart

```
START-HERE.md (you are here)
    │
    ├─→ Visual person?
    │   └─→ VIEW-IN-BOXES-LIVE.md → boxes-live
    │
    ├─→ Need quick overview?
    │   └─→ README.md
    │
    ├─→ Want detailed status?
    │   └─→ DASHBOARD.md
    │
    ├─→ Ready to work?
    │   └─→ NEXT-STEPS.md
    │
    ├─→ AI agent session?
    │   └─→ CLAUDE.md
    │
    └─→ Want full context?
        └─→ AUDIT-COMPLETE.md
```

---

## 🔗 External Links

- **GitHub Org:** https://github.com/jcaldwell-labs
- **my-context:** https://github.com/jcaldwell-labs/my-context
- **boxes-live:** https://github.com/jcaldwell-labs/boxes-live
- **fintrack:** https://github.com/jcaldwell-labs/fintrack
- **terminal-stars:** https://github.com/jcaldwell-labs/terminal-stars

Full project list in **README.md**

---

## 🎓 What You'll Learn

### About jcaldwell-labs
- **Vision:** Unix alternatives to enterprise tools
- **Philosophy:** Do one thing well, compose together
- **Projects:** 8 terminal-based tools (CLI, TUI, games)
- **Status:** Active development, ready for parallel work

### About the Workspace
- **Purpose:** Coordination hub for multi-project org
- **Tools:** my-context for tracking, boxes-live for visualization
- **Workflow:** Text docs + visual canvas + database tracking
- **Strategy:** Parallel agent sessions for rapid development

### About Dogfooding
This workspace demonstrates jcaldwell-labs tools in action:
- ✅ **my-context** tracked the audit work (db:jcaldwell_labs)
- ✅ **boxes-live** visualizes the organization (jcaldwell-labs-canvas.txt)
- ✅ **Unix philosophy** used throughout (composable text tools)

---

## 🚦 Status at a Glance

| Metric | Status |
|--------|--------|
| Projects | 8 ✅ |
| Open PRs | 4 🟡 |
| Active Development | All 8 🟢 |
| Days Since Commit | 0 ✅ |
| Documentation | Complete ✅ |
| Ready for Parallel Work | 18+ features ✅ |
| GitHub Stars | 0 🔴 |
| Test Coverage | Needs improvement 🟡 |

---

## 💡 Pro Tips

1. **Start visual** - Load boxes-live canvas first for overview
2. **Bookmark DASHBOARD** - Your daily go-to for status
3. **Use NEXT-STEPS** - Don't reinvent, use ready prompts
4. **Track in my-context** - All work goes in db partitions
5. **Update docs** - Keep DASHBOARD.md current as you work

---

## 🎯 Your Next Step

**Pick one:**

**[A] See it visually** → Read [VIEW-IN-BOXES-LIVE.md](./VIEW-IN-BOXES-LIVE.md)

**[B] Read overview** → Read [README.md](./README.md)

**[C] Check status** → Read [DASHBOARD.md](./DASHBOARD.md)

**[D] Start coding** → Read [NEXT-STEPS.md](./NEXT-STEPS.md)

**[E] AI agent mode** → Read [CLAUDE.md](./CLAUDE.md)

---

**Welcome to jcaldwell-labs! 🚀**

*Last updated: 2025-11-18 by jcaldwell-labs-audit session*
