# JCaldwell Labs - Next Steps & Parallel Work Opportunities

**Generated:** 2025-11-18
**Context:** jcaldwell-labs-audit-2025-11-18 (db:jcaldwell_labs)

---

## Executive Summary

The jcaldwell-labs organization has **8 active projects**, all updated within the last 48 hours, with **0 open PRs** and **clean build status**. The organization is in an active development phase with significant momentum.

**Key Opportunity:** Multiple projects are ready for parallel feature development, allowing multiple Claude Code agent sessions to work simultaneously.

---

## Project Status Overview

| Project | Language | Status | Priority | Next Action |
|---------|----------|--------|----------|-------------|
| **my-context** | Go | Production | HIGH | Add advanced features, documentation |
| **boxes-live** | C | MVP Complete | HIGH | UI enhancements, persistence |
| **fintrack** | Go | MVP Phase 1 | HIGH | Complete CRUD, add transactions |
| **terminal-stars** | C | Planning | MEDIUM | Implement core visualization |
| **tario** | C | Development | MEDIUM | Level design, physics refinement |
| **adventure-engine-v2** | C | Development | MEDIUM | DSL parser, game runtime |
| **smartterm-prototype** | C | POC | LOW | Decision: Extract library or minimal? |
| **.github** | Markdown | Complete | LOW | Update as org grows |

---

## Parallel Work Opportunities

These features can be developed **simultaneously** by separate agent sessions:

### Wave 1: High-Value Features (Start These First)

#### Agent Session 1: my-context - Advanced Query Features
**Project:** https://github.com/jcaldwell-labs/my-context
**Branch:** `feature/advanced-queries`
**Context Partition:** `db:my_context_dev`

**Tasks:**
1. Add full-text search across all note content
2. Implement time-range filtering (--since, --until flags)
3. Add note export with multiple formats (JSON, CSV, HTML)
4. Create graph visualization of context relationships

**Prompt:**
```
Clone jcaldwell-labs/my-context and implement advanced query features:
- Full-text search across notes with --note-search flag
- Time range filters: --since and --until
- Multiple export formats: --format json|csv|html|md
- Context relationship graph: --graph flag to show parent/child relationships

Use database mode (MY_CONTEXT_HOME=db:my_context_dev) to track your work.
Follow Go best practices, add comprehensive tests, update README.
```

---

#### Agent Session 2: boxes-live - Save/Load & Multiple Canvases
**Project:** https://github.com/jcaldwell-labs/boxes-live
**Branch:** `feature/persistence`
**Context Partition:** `db:boxes_live_dev`

**Tasks:**
1. Implement save canvas to JSON file
2. Implement load canvas from JSON file
3. Add canvas switching (multiple canvases in memory)
4. Add canvas naming and metadata

**Prompt:**
```
Clone jcaldwell-labs/boxes-live and implement canvas persistence:
- Save current canvas to JSON file (':s filename.json' command)
- Load canvas from JSON file (':l filename.json' command)
- Support multiple canvases in memory (':n new-canvas-name' to create/switch)
- Add canvas metadata (name, created time, modified time)

The project uses C and ncurses. Follow the existing architecture.
Use MY_CONTEXT_HOME=db:boxes_live_dev to track your work.
```

---

#### Agent Session 3: fintrack - Transaction Management
**Project:** https://github.com/jcaldwell-labs/fintrack
**Branch:** `feature/transactions`
**Context Partition:** `db:fintrack_dev`

**Tasks:**
1. Design transaction model (GORM)
2. Implement transaction CRUD operations
3. Add transaction repository with tests
4. Link transactions to accounts
5. Update account balances automatically

**Prompt:**
```
Clone jcaldwell-labs/fintrack and implement transaction management:
- Create Transaction model (Date, Amount, Description, FromAccount, ToAccount, Category, etc.)
- Implement TransactionRepository with CRUD operations
- Add unit tests following existing test patterns
- Auto-update account balances when transactions are created/deleted
- Use PostgreSQL with GORM (follow existing Account model patterns)

Use MY_CONTEXT_HOME=db:fintrack_dev to track decisions and progress.
All tests must pass before committing.
```

---

### Wave 2: Core Feature Development

#### Agent Session 4: terminal-stars - Core Starfield Implementation
**Project:** https://github.com/jcaldwell-labs/terminal-stars
**Branch:** `feature/core-starfield`
**Context Partition:** `db:terminal_stars_dev`

**Tasks:**
1. Implement basic star particle system
2. Add frame buffer for smooth rendering
3. Implement linear motion effect
4. Add keyboard controls (speed, direction)
5. Target 60fps with ncurses

**Prompt:**
```
Clone jcaldwell-labs/terminal-stars and implement core starfield visualization:
- Star particle system with x,y,z coordinates
- Double-buffered rendering for smooth animation
- Linear motion effect (stars moving toward viewer)
- Keyboard controls: arrow keys for direction, +/- for speed
- Target 60fps using ncurses

Follow existing C/ncurses patterns from boxes-live.
Use MY_CONTEXT_HOME=db:terminal_stars_dev for tracking.
```

---

#### Agent Session 5: tario - Level Editor
**Project:** https://github.com/jcaldwell-labs/tario
**Branch:** `feature/level-editor`
**Context Partition:** `db:tario_dev`

**Tasks:**
1. Create simple level editor mode
2. Allow placing platforms, enemies, coins
3. Save levels to JSON format
4. Load custom levels into game

**Prompt:**
```
Clone jcaldwell-labs/tario and implement a level editor:
- Toggle into editor mode with 'E' key
- Place tiles with keyboard/mouse: platforms (P), enemies (M), coins (C)
- Save level to JSON file (':save level1.json')
- Load custom levels (':load level1.json')

The game uses C with ANSI escape codes.
Use MY_CONTEXT_HOME=db:tario_dev to track your work.
```

---

#### Agent Session 6: adventure-engine-v2 - DSL Parser
**Project:** https://github.com/jcaldwell-labs/adventure-engine-v2
**Branch:** `feature/dsl-parser`
**Context Partition:** `db:adventure_v2_dev`

**Tasks:**
1. Design adventure DSL syntax (YAML or custom)
2. Implement parser for rooms, items, actions
3. Build game state machine
4. Create sample adventure to validate DSL

**Prompt:**
```
Clone jcaldwell-labs/adventure-engine-v2 and implement the DSL parser:
- Design DSL syntax for defining rooms, items, NPCs, actions
- Implement parser to load DSL into game structures
- Build game state machine for navigation and interactions
- Create a sample adventure (3-5 rooms) to validate the DSL

The project is in C with a smart terminal UI.
Use MY_CONTEXT_HOME=db:adventure_v2_dev for tracking decisions.
```

---

### Wave 3: Documentation & Polish

#### Agent Session 7: Cross-Project Documentation Sprint
**Branch:** `docs/comprehensive-readmes`
**Context Partition:** `db:docs_sprint`

**Tasks:**
For each project without comprehensive docs:
1. Add architecture diagrams (ASCII art or mermaid)
2. Create CONTRIBUTING.md
3. Add usage examples with GIFs/screenshots
4. Write troubleshooting guides
5. Document build requirements

**Prompt:**
```
Conduct a documentation sprint across jcaldwell-labs projects:
1. Review each project's README for completeness
2. Add architecture diagrams (ASCII art or mermaid.js)
3. Create CONTRIBUTING.md with:
   - How to build and test
   - Code style guidelines
   - PR process
4. Add visual examples (describe what screenshots/GIFs should show)
5. Document common issues and solutions

Focus on: terminal-stars, tario, adventure-engine-v2
Use MY_CONTEXT_HOME=db:docs_sprint for coordination.
```

---

## Suggested Follow-Up Prompts by Project

### For my-context

**Current State:** Production-ready, database backend operational
**GitHub:** https://github.com/jcaldwell-labs/my-context

#### Prompt 1: Performance Optimization
```
Analyze my-context database queries for performance bottlenecks.
Add indexes where needed, optimize the full-text search implementation.
Run benchmarks comparing before/after performance.
Target: <10ms for all queries on database with 10,000+ contexts.
```

#### Prompt 2: Team Features
```
Implement team collaboration features for my-context:
- Shared contexts (multiple users can add notes)
- Context permissions (read/write/admin)
- Activity log (who added what when)
- Context mentions (@user in notes)
Use PostgreSQL role-based permissions where possible.
```

#### Prompt 3: Integration Ecosystem
```
Create my-context integrations:
- Git hooks (auto-track files on commit)
- Jira/GitHub issue linking
- Slack notifications for context changes
- Export to common formats (Notion, Obsidian, Markdown)
Make each integration a separate plugin/module.
```

---

### For boxes-live

**Current State:** MVP with pan/zoom working
**GitHub:** https://github.com/jcaldwell-labs/boxes-live

#### Prompt 1: Drawing Tools
```
Add drawing tools to boxes-live:
- Line drawing tool (L key + click two points)
- Text annotation tool (T key + type text)
- Arrow drawing (A key for connections between boxes)
- Freehand drawing mode
All tools should respect pan/zoom transformations.
```

#### Prompt 2: Collaboration Features
```
Implement real-time collaboration for boxes-live:
- Server mode (share canvas over network)
- Client mode (connect to shared canvas)
- Show other users' cursors
- Lock mechanism (prevent simultaneous edits)
Use plain TCP sockets for simplicity (no external dependencies).
```

#### Prompt 3: Export & Import
```
Add export capabilities to boxes-live:
- Export to ASCII art (plain text representation)
- Export to SVG (vector graphics)
- Export to PNG (via ASCII-to-image renderer)
- Import from Miro (parse Miro JSON exports)
Focus on making the output shareable and version-control friendly.
```

---

### For fintrack

**Current State:** Phase 1 MVP - Account CRUD complete
**GitHub:** https://github.com/jcaldwell-labs/fintrack

#### Prompt 1: CSV Import
```
Implement bank statement CSV import for fintrack:
- Auto-detect CSV format (Chase, Wells Fargo, Bank of America)
- Map columns to transaction fields
- Handle duplicate detection
- Preview before import
- Support custom CSV mapping via config file
```

#### Prompt 2: Budget Tracking
```
Add budget tracking to fintrack:
- Define budgets by category and time period (monthly/yearly)
- Track spending against budgets
- Alert when approaching or exceeding budget
- Budget vs actual reports
- Rollover unused budget to next period (optional)
```

#### Prompt 3: Reporting & Visualization
```
Create terminal-based reports and visualizations for fintrack:
- Cash flow chart (ASCII art line/bar charts)
- Spending by category (pie chart in terminal)
- Account balance trends over time
- Net worth calculation and tracking
Use terminal visualization libraries or custom ASCII rendering.
```

---

### For terminal-stars

**Current State:** Planning phase, frame buffering designed
**GitHub:** https://github.com/jcaldwell-labs/terminal-stars

#### Prompt 1: Multiple Effects
```
Implement multiple motion effects for terminal-stars:
- Linear motion (current)
- Spiral motion (stars spiral outward)
- Warp speed (stars stretch into lines)
- Tunnel effect (circular motion)
- Wave motion (sine wave patterns)
Allow switching between effects with number keys (1-5).
```

#### Prompt 2: Color & Depth
```
Add color and depth perception to terminal-stars:
- Use terminal 256-color palette
- Closer stars = brighter/whiter
- Distant stars = dimmer/bluer
- Add depth-based size variation
- Smooth color transitions as stars move
```

#### Prompt 3: Music Sync
```
Add music synchronization to terminal-stars:
- Read audio input (or FIFO pipe)
- Adjust star speed/density based on beat detection
- Color changes based on frequency spectrum
- Create "visualizer mode" for music playback
Use ALSA or PulseAudio for audio input.
```

---

### For tario

**Current State:** Platformer physics working, basic levels
**GitHub:** https://github.com/jcaldwell-labs/tario

#### Prompt 1: Enemy AI
```
Implement enemy AI for tario platformer:
- Patrol pattern (move back and forth)
- Chase player when in range
- Jump to reach platforms
- Different enemy types (fast, slow, flying)
- Collision detection with player (damage/death)
```

#### Prompt 2: Power-ups & Items
```
Add power-ups and collectibles to tario:
- Double jump ability
- Speed boost
- Invincibility (temporary)
- Extra lives
- Score multipliers
Display inventory in status bar.
```

#### Prompt 3: Boss Battles
```
Design and implement boss battles for tario:
- Boss at end of each world
- Multi-phase battles (boss changes behavior at 50% health)
- Special attacks and patterns
- Victory animation and rewards
Create at least one boss with 2-3 attack patterns.
```

---

### For adventure-engine-v2

**Current State:** Terminal UI working, DSL planning
**GitHub:** https://github.com/jcaldwell-labs/adventure-engine-v2

#### Prompt 1: Complete Sample Adventure
```
Create a complete sample adventure for adventure-engine-v2:
- 10-15 interconnected rooms
- Puzzle requiring multiple items/actions
- NPCs with dialogue trees
- Multiple endings based on choices
- Easter eggs and hidden content
This validates the DSL and serves as documentation.
```

#### Prompt 2: Combat System
```
Add an optional combat system to adventure-engine-v2:
- Turn-based combat mechanics
- Character stats (HP, attack, defense)
- Inventory management (weapons, armor, potions)
- Enemy encounters and loot drops
Make it modular so adventures can opt-in/out of combat.
```

#### Prompt 3: Save System
```
Implement save/load functionality for adventure-engine-v2:
- Save game state to file
- Auto-save on room transitions
- Multiple save slots
- Save file integrity checking
- Cloud save support (optional, via rsync or git)
```

---

### For smartterm-prototype

**Current State:** POC complete, decision point
**GitHub:** https://github.com/jcaldwell-labs/smartterm-prototype

#### Prompt 1: Decision Analysis
```
Analyze smartterm-prototype and provide recommendations:
- Compare "full library" vs "minimal extraction" approaches
- Identify which components are reusable across projects
- Estimate effort for each approach
- Recommend best path forward with rationale
Consider: boxes-live, terminal-stars, tario all need terminal UI.
```

#### Prompt 2: Minimal Extraction
```
Extract the minimal useful components from smartterm-prototype:
- Scrolling output buffer (most reusable)
- Status bar rendering
- Input handling helpers
Create a single-header library (stb-style) for easy inclusion.
Document with usage examples.
```

#### Prompt 3: Full Library Design
```
Design a full terminal UI library from smartterm-prototype:
- Component architecture (windows, panels, status bars, menus)
- Event system (keyboard, mouse, resize)
- Layout engine
- Theme/styling support
Provide detailed API design doc, not full implementation yet.
```

---

## Coordination Strategy

### Session Management

**Use dedicated my-context partitions for each project:**

```bash
# When starting work on a project
export MY_CONTEXT_HOME=db:<project>_dev
my-context start "feature-<name>-$(date +%Y-%m-%d)"

# When coordinating across projects
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "coordination-<topic>"
```

### Parallel Agent Workflow

1. **Morning: Launch Wave 1 Sessions** (3 agents)
   - my-context advanced queries
   - boxes-live persistence
   - fintrack transactions

2. **Midday: Check Progress**
   - Review PRs as they come in
   - Unblock any agents stuck on decisions

3. **Afternoon: Launch Wave 2 Sessions** (3 agents)
   - terminal-stars core implementation
   - tario level editor
   - adventure-engine DSL parser

4. **Evening: Integration & Review**
   - Merge completed PRs
   - Test integrated features
   - Plan next wave

### Progress Tracking

Track overall progress in the coordination partition:

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "progress-review-$(date +%Y-%m-%d)"

# Check status of all projects
for repo in my-context boxes-live fintrack terminal-stars tario adventure-engine-v2; do
  echo "=== $repo ==="
  gh pr list --repo jcaldwell-labs/$repo --state open
  echo ""
done

# Document findings
my-context note "Status update: <what's complete, what's blocked, next priorities>"
```

---

## Priority Recommendations

### This Week (High Impact)

1. **my-context advanced queries** - Increases tool utility significantly
2. **boxes-live persistence** - Makes it actually usable day-to-day
3. **fintrack transactions** - Core functionality for financial tracking

### Next Week (Building Momentum)

4. **terminal-stars core visualization** - Showcase project
5. **Documentation sprint** - Improves discoverability
6. **tario level editor** - Community contribution enabler

### This Month (Long-term Value)

7. **adventure-engine DSL** - Unlocks content creation
8. **my-context team features** - Enterprise appeal
9. **boxes-live collaboration** - Unique differentiator

---

## Success Metrics

Track these weekly:

- **PRs merged** - Velocity indicator
- **New features shipped** - Value delivery
- **Test coverage** - Quality metric
- **Documentation pages** - Discoverability
- **GitHub stars** - Community interest (target: 10 by end of month)

---

## Notes

**All prompts assume:**
- Agent has access to gh CLI and git
- Database (PostgreSQL) is running for my-context
- Build tools are available (make, gcc, go)
- Agent will create comprehensive tests
- Agent will update documentation

**Context partitions are namespace-isolated** - Each project's work is tracked separately for clarity, but all are queryable from the central database.

**Ready to launch agents!** 🚀

Pick any prompt above and start a new Claude Code session to make progress in parallel.
