# View JCaldwell Labs Audit in boxes-live

**Dogfooding our own tools!** This guide shows how to explore the jcaldwell-labs audit using boxes-live, demonstrating the Unix philosophy of composable tools.

---

## Quick Start

### Option 1: View Pre-Generated Canvas

```bash
cd ~/projects/boxes-live
boxes-live

# Press F3 (Load Canvas)
# Type: ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt
# Press Enter
```

### Option 2: Generate Fresh Canvas

```bash
cd ~/projects/boxes-live

# Generate canvas from live data
./connectors/jcaldwell-labs2canvas > ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt

# Load in boxes-live
boxes-live
# F3 → ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt
```

---

## What You'll See

The canvas contains **16 interactive boxes** organized spatially:

### Top Row (Y=50-200): Organization Overview
- **JCaldwell Labs Organization** (Cyan) - Title box with key stats

### Project Status (Y=200-450): Color-Coded by Maturity
- **my-context** (Green) - Production ready Go tool
- **boxes-live** (Blue) - MVP complete C application
- **fintrack** (Yellow) - Phase 1 MVP in progress
- **smartterm-prototype** (Magenta) - At decision point

### Active Development (Y=450-700): C Projects
- **terminal-stars** (Yellow) - Visualization with open PR
- **tario** (Yellow) - Platformer game
- **adventure-engine-v2** (Yellow) - Text adventure engine

### Action Items (Y=700-1000): Work To Do
- **Open PRs (4 Total)** (Red) - All pending PRs with details
- **Ready for Parallel Work** (Cyan) - 18+ prompts in 3 waves
- **Next 24 Hours** (Red) - Priority actions
- **Unix Philosophy Mapping** (Cyan) - Enterprise alternatives

### Metrics & Documentation (Y=1000-1200): Project Health
- **Health Metrics** (Green) - Current status indicators
- **my-context Partitions** (Blue) - Database structure
- **Documentation Created** (Cyan) - All generated files

---

## Navigation

### Basic Controls
- **Arrow Keys** - Pan the canvas
- **+/-** - Zoom in/out
- **HOME** - Reset to origin (0,0)
- **F3** - Load different canvas
- **q** - Quit

### Finding Specific Information

**To find a specific project:**
1. Press HOME to reset view
2. Use arrow keys to navigate:
   - **Right** → See fintrack, smartterm-prototype
   - **Down** → See terminal-stars, tario, adventure-engine-v2
   - **Down x2** → See PRs, parallel work opportunities
   - **Down x3** → See health metrics and documentation

**Project Locations (approximate X,Y):**
```
Title:              800, 50
my-context:         200, 200
boxes-live:         600, 200
fintrack:          1000, 200
smartterm:         1400, 200
terminal-stars:     200, 450
tario:              600, 450
adventure-v2:      1000, 450
Open PRs:           200, 700
Parallel Work:      800, 700
Next 24hrs:        1250, 700
Unix Mapping:      1400, 450
Health:             200, 1000
Partitions:         700, 1000
Documentation:     1250, 1000
```

---

## Color Legend

boxes-live uses colors to convey status:

| Color | Number | Meaning | Used For |
|-------|--------|---------|----------|
| Red | 1 | Urgent/Action Required | Open PRs, Priority actions |
| Green | 2 | Production/Healthy | my-context, Health metrics |
| Yellow | 3 | Active Development | fintrack, terminal-stars, tario, adventure-v2 |
| Blue | 4 | Stable/MVP | boxes-live, Context partitions |
| Magenta | 5 | Decision Point | smartterm-prototype |
| Cyan | 6 | Information/Overview | Title, Documentation, Vision |

---

## Use Cases

### 1. Daily Standup
Navigate to **"Next 24 Hours"** box (1250, 700) to see priority actions:
- Review PRs
- Launch parallel work
- Complete documentation

### 2. Pick a Feature to Implement
Go to **"Ready for Parallel Work"** box (800, 700):
- Wave 1 = High value features (start now)
- Wave 2 = Core features (this week)
- Wave 3 = Documentation (ongoing)

### 3. Check Project Health
Visit **"Health Metrics"** box (200, 1000):
- See what's working (✓)
- See what needs attention (⚠)
- See what's missing (✗)

### 4. Understand Architecture
Look at **"my-context Partitions"** box (700, 1000):
- See database structure
- Understand project isolation
- Learn partition naming

### 5. Review Open Work
Check **"Open PRs (4 Total)"** box (200, 700):
- All pending PRs listed
- Status and impact shown
- Review priorities clear

---

## Updating the Canvas

As work progresses, regenerate the canvas:

```bash
cd ~/projects/boxes-live

# Generate fresh canvas with current data
./connectors/jcaldwell-labs2canvas > ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt

# Reload in boxes-live (F3)
```

**Note:** The connector reads from static audit files. To make it dynamic:
1. Update DASHBOARD.md with current status
2. Regenerate canvas
3. Reload in boxes-live

---

## Creating Custom Views

Use the `boxes-cli` tool to create custom canvases:

```bash
cd ~/projects/boxes-live

# Create custom canvas
./connectors/boxes-cli create my-view.txt --width 2000 --height 1500

# Add boxes focusing on what you care about
./connectors/boxes-cli add my-view.txt \
    --x 100 --y 100 \
    --title "My Focus Today" \
    --color 1 \
    --content "PR #5 review" "fintrack transactions" "boxes-live persistence"

# Add more boxes...

# Load in boxes-live
boxes-live  # F3 → my-view.txt
```

---

## Connector Architecture

The `jcaldwell-labs2canvas` connector demonstrates the Unix philosophy:

1. **Single Purpose:** Convert audit data → visual canvas
2. **Text Input:** Reads markdown files (DASHBOARD.md, etc.)
3. **Text Output:** Produces boxes-live canvas format
4. **Composable:** Can be piped, redirected, automated
5. **Scriptable:** Pure bash, no dependencies beyond boxes-cli

### Connector Workflow

```
DASHBOARD.md ──┐
NEXT-STEPS.md ─┼─→ jcaldwell-labs2canvas ─→ canvas.txt ─→ boxes-live
README.md ─────┘                                              (visual)
```

---

## Advanced: Live Updates

To auto-refresh the canvas when audit files change:

```bash
cd ~/projects/jcaldwell-labs

# Watch for changes and regenerate
while inotifywait -e modify DASHBOARD.md NEXT-STEPS.md README.md; do
    cd ~/projects/boxes-live
    ./connectors/jcaldwell-labs2canvas > ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt
    echo "Canvas regenerated at $(date)"
done
```

Then in boxes-live, press F3 and reload to see updates.

---

## Exporting the View

Share the visual representation:

```bash
cd ~/projects/boxes-live

# Export to ASCII art (plain text)
./connectors/boxes-cli export ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt \
    --format ascii > jcaldwell-labs-ascii.txt

# Export to Markdown
./connectors/boxes-cli export ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt \
    --format markdown > jcaldwell-labs-visual.md
```

---

## Comparison: Text vs Visual

### Traditional Text Reports
```
# Reading DASHBOARD.md
- Linear, top-to-bottom
- Hard to see relationships
- No spatial context
- Sequential navigation
```

### boxes-live Visual
```
# Exploring jcaldwell-labs-canvas.txt
- Spatial, 2D layout
- Relationships via proximity
- Color-coded status
- Non-linear exploration
```

**Both are valuable!** Text for detailed reading, visual for overview and exploration.

---

## What This Demonstrates

### Unix Philosophy in Action
1. **my-context** - Tracked the audit work
2. **jcaldwell-labs audit** - Generated text reports
3. **jcaldwell-labs2canvas** - Converted text → visual
4. **boxes-live** - Displayed the visual canvas
5. **All composable** - Each tool does one thing well

### Dogfooding Success Criteria
- ✅ Used boxes-live to visualize jcaldwell-labs data
- ✅ Used boxes-cli to generate canvas programmatically
- ✅ Demonstrated connector architecture
- ✅ Showed text → visual transformation
- ✅ Proved Unix philosophy works at scale

---

## Troubleshooting

### Canvas doesn't load
```bash
# Check file exists
ls -lh ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt

# Check format
head ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt
# Should start with: viewport_x=... viewport_y=... box_count=...
```

### Boxes appear cut off
- Zoom out with `-` key
- Press HOME to reset viewport
- Canvas is 2000x1500, ensure you're not zoomed in too far

### Can't find a specific box
- Use coordinates listed in "Project Locations" section above
- Navigate with arrow keys
- Remember: +X = right, +Y = down

---

## Next Steps

### Enhance the Connector
1. **Add dynamic data** - Read from GitHub API, my-context database
2. **Show connections** - Draw lines between related projects
3. **Add timestamps** - Show when each box was last updated
4. **Color animations** - Flash red for urgent PRs

### Create More Connectors
- `github-prs2canvas` - All org PRs in one view
- `my-context2canvas` - Visualize context relationships
- `fintrack2canvas` - Account balances and cash flow
- `git-history2canvas` - Commit timeline visualization

### Build a Dashboard
Combine multiple canvases into a live dashboard:
- Organization overview (this canvas)
- Project details (per-project canvases)
- Real-time metrics (updated every minute)

---

## Files

| File | Purpose |
|------|---------|
| `jcaldwell-labs-canvas.txt` | Generated canvas (load in boxes-live) |
| `boxes-live/connectors/jcaldwell-labs2canvas` | Generator script |
| `boxes-live/connectors/boxes-cli` | Canvas manipulation CLI |
| `VIEW-IN-BOXES-LIVE.md` | This file - usage guide |

---

## Summary

**You've just:**
1. Generated a visual canvas from text audit data
2. Explored 16 boxes showing project status
3. Experienced Unix philosophy in action
4. Dogfooded boxes-live to understand jcaldwell-labs

**This proves:**
- Terminal tools can compete with GUI apps
- Text-based data can be visualized effectively
- Composable tools create powerful workflows
- jcaldwell-labs vision is achievable

---

**Ready to explore?**

```bash
cd ~/projects/boxes-live
boxes-live
# Press F3
# Type: ~/projects/jcaldwell-labs/jcaldwell-labs-canvas.txt
# Navigate and discover!
```

🚀 **Dogfooding complete!**
