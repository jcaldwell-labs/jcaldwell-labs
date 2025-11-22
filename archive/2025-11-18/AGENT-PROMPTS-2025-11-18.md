# Jcaldwell-Labs Multi-Agent Session Prompts
**Generated**: 2025-11-18
**Purpose**: Resource-intensive prompts for isolated Claude Code sessions
**Target**: Remote container environments with generic Debian setup

---

## Overview

These prompts are designed to:
- Move each project forward on its roadmap
- Be resource-intensive but valuable
- Work in isolated remote Claude Code sessions
- Require minimal human intervention
- Produce tangible, mergeable results

Each prompt assumes:
- Generic remote container (Debian-based)
- Claude Code environment
- Git access configured
- Standard development tools available
- No access to custom Debian 13 setup or persistent human oversight

---

## 1. boxes-live: Complete Connector Integration Testing

```
PROJECT: boxes-live
GOAL: Comprehensive integration testing and documentation for all connectors

CONTEXT:
- Current PR review files exist but need validation
- boxes-live is the flagship "Miro for terminal" project
- Multiple connectors exist: pstree2canvas, jcaldwell-labs2canvas, boxes-cli
- Need to ensure all workflows are documented and tested

TASKS:
1. Review existing connectors in ./connectors/
2. Create comprehensive test suite for each connector:
   - Test pstree2canvas with various process trees
   - Test jcaldwell-labs2canvas with GitHub organization data
   - Test boxes-cli list and boxes-cli stats commands
3. Document connector usage patterns in a new CONNECTOR-GUIDE.md
4. Create example workflows showing:
   - How to visualize GitHub org structure
   - How to monitor system processes
   - How to integrate custom data sources
5. Write integration tests that validate:
   - Canvas file format correctness
   - Box positioning and sizing algorithms
   - Edge cases and error handling
6. Create video workflow documentation (markdown with embedded commands)
7. Update main README.md with connector ecosystem overview

DELIVERABLES:
- tests/connector_integration_test.sh (comprehensive test suite)
- docs/CONNECTOR-GUIDE.md (usage patterns and examples)
- docs/WORKFLOW-EXAMPLES.md (real-world use cases)
- Updated README.md with connector ecosystem section
- All tests passing with documented results

SUCCESS CRITERIA:
- All connectors tested with multiple input scenarios
- Clear documentation for custom connector development
- Examples demonstrable in isolated container environment
- PR-ready code with commit messages following project style
```

---

## 2. atari-style: Terminal Arcade Enhancement

```
PROJECT: atari-style
GOAL: Implement Terminal Arcade launcher and complete Mandelbrot explorer

CONTEXT:
- Files exist for terminal_arcade/ directory
- TERMINAL_ARCADE_PROGRESS.md and MANDELBROT_ENHANCEMENTS.md present
- Project has mature games (Pac-Man, Galaga, Breakout, Grand Prix)
- Need unified launcher and mathematical visualization tool

TASKS:
1. Complete Terminal Arcade implementation:
   - Review terminal_arcade/ directory structure
   - Implement run_terminal_arcade.py as unified launcher
   - Create category-based menu system (Arcade, Creative, Demos, Math)
   - Add metadata for each game (difficulty, duration estimate, controls)
   - Implement recently played tracking
2. Enhance Mandelbrot explorer:
   - Implement zoom functionality with smooth animation
   - Add color scheme cycling (HSV, grayscale, rainbow, thermal)
   - Julia set variant selection
   - Pan controls with keyboard and joystick
   - Save/load coordinate bookmarks
   - Performance optimization for deep zooms
3. Integration testing:
   - Test all games launch correctly from Terminal Arcade
   - Verify joystick support across all programs
   - Ensure consistent exit behavior (ESC/Q)
   - Test terminal resize handling
4. Documentation:
   - Update CLAUDE.md with Terminal Arcade architecture
   - Create MATH-VISUALIZATIONS.md for Mandelbrot/Julia docs
   - Add screenshots (ASCII art representations)
   - Document color scheme algorithms

DELIVERABLES:
- terminal_arcade/ fully implemented with launcher
- Enhanced Mandelbrot/Julia set explorer
- Updated main menu to include Terminal Arcade option
- Comprehensive documentation
- Test script verifying all integrations

SUCCESS CRITERIA:
- Terminal Arcade launches all existing games
- Mandelbrot explorer has zoom, pan, and color cycling
- All joystick controls working
- Documentation complete for new features
- Code follows project conventions (see CLAUDE.md)
```

---

## 3. terminal-stars: Complete Phase 4 Effects System

```
PROJECT: terminal-stars
GOAL: Implement all 6 starfield effects per roadmap

CONTEXT:
- Phase 1-3 complete (foundation, motion, controls)
- Open PR #5 for horizon feature
- JOYSTICK-SUCCESS.md indicates joystick integration working
- Architecture in place for effect system (see CLAUDE.md)

TASKS:
1. Review and test existing implementation:
   - Verify linear starfield effect (Phase 2 complete)
   - Test current controls (pan, zoom, speed)
   - Review PR #5 for horizon feature
2. Implement remaining 5 effects (Phase 4):
   - SPIRAL: Stars rotate around center while moving forward
   - WARP: Star speed accelerates progressively (warp effect)
   - TUNNEL: Stars arranged in cylindrical tunnel pattern
   - EXPLODE: Stars burst outward from center
   - WAVE: Sinusoidal wave motion overlaid on forward movement
3. Add effect switching:
   - Number keys 1-6 to switch effects
   - Visual feedback showing current effect name
   - Smooth transitions between effects
   - Effect-specific parameter tuning (joystick axes)
4. Implement Phase 5 polish:
   - Color/brightness variation based on depth
   - Motion blur trails for near stars
   - Optimize rendering for 60fps consistency
   - Handle terminal resize gracefully
   - Add FPS counter (togglable with F key)
5. Testing:
   - Verify all effects at different speeds
   - Test effect transitions
   - Validate terminal resize handling
   - Performance profiling

DELIVERABLES:
- effects.c with all 6 effect implementations
- Updated main.c with effect switching
- Performance optimizations documented
- Updated README.md with effect descriptions
- Test results and performance benchmarks

SUCCESS CRITERIA:
- All 6 effects implemented and working
- Smooth 60fps rendering maintained
- Effect switching seamless
- Code compiles with no warnings
- Follows boxes-live frame buffering patterns
```

---

## 4. tario: Implement Core Game Loop and First Level

```
PROJECT: tario
GOAL: Create playable MVP with one complete level

CONTEXT:
- Minimal files exist, early stage project
- CLAUDE.md outlines architecture (ANSI escape codes, terminal raw mode)
- Inspired by Super Mario Bros and Ghosts 'n Goblins
- C-based with termios.h for terminal control

TASKS:
1. Establish build system:
   - Create Makefile with debug/release targets
   - Set up include/ and src/ directory structure
   - Configure compiler flags for POSIX compliance
2. Implement terminal rendering engine:
   - ANSI escape code wrapper functions
   - Double buffering to prevent flicker
   - Screen clear and cursor positioning
   - Color support (8-color ANSI)
3. Implement game loop:
   - Non-blocking input handling (termios raw mode)
   - Fixed timestep physics (60fps target)
   - Render pipeline (buffer -> ANSI -> terminal)
   - Frame timing with nanosleep
4. Create player character system:
   - Player sprite (ASCII art character representation)
   - Movement physics (velocity, acceleration, friction)
   - Jump mechanics with gravity
   - Collision detection with tiles
5. Build level system:
   - Tile-based level representation (2D array)
   - First level design (platforming challenge)
   - Scrolling viewport (follows player)
   - Platform collision (solid tiles)
6. Polish MVP:
   - Player animation (walk cycle, jump frame)
   - Death/respawn system
   - Simple HUD (lives, score)
   - Victory condition (reach goal)

DELIVERABLES:
- Complete Makefile build system
- src/main.c (game loop)
- src/terminal.c (ANSI rendering)
- src/player.c (character physics)
- src/level.c (tile system and first level)
- include/ headers for all modules
- README.md with build/play instructions

SUCCESS CRITERIA:
- Game compiles and runs in terminal
- Player can move, jump, and collide with platforms
- First level is completable
- Smooth 60fps rendering
- Clean exit on Q key
- No memory leaks (valgrind clean)
```

---

## 5. smartterm-prototype: Extract and Document Library API

```
PROJECT: smartterm-prototype
GOAL: Create reusable smartterm library with documentation

CONTEXT:
- POC complete (~250 LOC)
- PR #2 open for CLAUDE.md
- Successfully proved ncurses + readline integration
- adventure-engine-v2 uses extracted smartterm_simple
- Decision point: Path A (full library) vs Path B (minimal extraction)

TASKS:
1. Review POC learnings:
   - Read NEXT-STEPS.md for opportunity cost analysis
   - Review POC limitations (multi-line input, flicker on suspend/resume)
   - Analyze adventure-engine-v2 usage of smartterm_simple
2. Extract production-ready library:
   - Create lib/smartterm/ directory structure
   - Design clean API (init, cleanup, write, read_line, status_bar)
   - Implement thread-safe output buffer
   - Add configurable themes (colors, symbols)
   - Improve suspend/resume to reduce flicker
3. Advanced features:
   - Multi-line input support (custom handler, not readline)
   - Scrollback navigation (PgUp/PgDn)
   - Search in output buffer (Ctrl+F)
   - Export buffer to file
   - Tab completion framework (pluggable)
4. Create example applications:
   - examples/chat_client.c (IRC-style interface)
   - examples/log_viewer.c (real-time log monitoring)
   - examples/repl.c (programming language REPL)
5. Comprehensive documentation:
   - API reference with function signatures
   - Architecture diagrams (ASCII art)
   - Integration guide for new projects
   - Migration guide from POC to library
   - Performance considerations

DELIVERABLES:
- lib/smartterm/ with production API
- include/smartterm.h public header
- 3 example applications
- docs/SMARTTERM-API.md (comprehensive reference)
- docs/ARCHITECTURE.md (design decisions)
- Updated README.md with library overview

SUCCESS CRITERIA:
- Library API is clean and documented
- Examples compile and demonstrate features
- Reduced flicker on suspend/resume
- Multi-line input working
- Ready for use in other projects
- PR #2 merged with enhanced documentation
```

---

## 6. fintrack: Implement Transaction Management (Phase 1)

```
PROJECT: fintrack
GOAL: Complete Phase 1 transaction CRUD operations

CONTEXT:
- Account management complete (PR ready)
- PR #3 open for CLAUDE.md
- PostgreSQL schema ready with 8 core tables
- Go/Cobra/GORM stack established
- Following TDD approach

TASKS:
1. Review current state:
   - Verify account operations working
   - Review PostgreSQL schema (fintrack_schema.sql)
   - Check existing models and repositories
2. Implement transaction models:
   - Transaction struct in internal/models/
   - Validation rules (amount, date, category)
   - Relationship to Account and Category models
3. Create transaction repository:
   - CRUD operations with GORM
   - Query builders (filter by date, category, account)
   - Pagination support for large datasets
   - Transaction total calculations
4. Build transaction commands:
   - `fintrack transaction add` (with category, date, note)
   - `fintrack transaction list` (filterable, sortable)
   - `fintrack transaction show <id>`
   - `fintrack transaction update <id>`
   - `fintrack transaction delete <id>`
   - Short aliases: `fintrack tx add`, etc.
5. Output formatting:
   - Table view with columns (Date, Description, Category, Amount, Balance)
   - JSON output for scripting
   - Summary totals (income, expenses, net)
6. Write comprehensive tests:
   - Unit tests for repository methods
   - Integration tests with PostgreSQL
   - Command tests with mock data
   - Edge cases (negative amounts, invalid dates)
7. Category management:
   - `fintrack category add <name>`
   - `fintrack category list`
   - Default categories (Housing, Food, Transport, Income, etc.)
   - Category-based filtering

DELIVERABLES:
- internal/models/transaction.go
- internal/db/repositories/transaction_repository.go
- internal/commands/transaction.go
- internal/commands/category.go
- tests/unit/transaction_test.go
- tests/integration/transaction_integration_test.go
- Updated README.md with transaction commands

SUCCESS CRITERIA:
- Full CRUD for transactions
- Categories working with relationships
- All tests passing
- JSON output functional
- TDD approach followed (tests written first)
- Database triggers working (balance updates)
- PR-ready code
```

---

## 7. adventure-engine-v2: World Scripting and Save/Load

```
PROJECT: adventure-engine-v2
GOAL: Implement world file format and game save/load

CONTEXT:
- MVP complete (3 hours, Nov 17)
- smartterm_simple library working well
- Basic parser and world system functional
- README.md shows "Next Steps" for world scripting and save/load

TASKS:
1. Design world file format:
   - YAML or custom DSL for room definitions
   - Room properties: name, description, exits, items
   - Item properties: name, description, takeable, usable
   - NPC definitions (for future expansion)
   - Example: worlds/dark_tower.world
2. Implement world loader:
   - Parser for world file format
   - Validation (check exit consistency, item references)
   - Error reporting with line numbers
   - Dynamic room/item allocation
3. Create save/load system:
   - Save format: current room, inventory, world state
   - Filename: ~/.adventure-saves/<world_name>.sav
   - Commands: `save <slot>`, `load <slot>`, `saves`
   - Autosave on quit (optional)
4. Create 2-3 new worlds:
   - "The Haunted Mansion" (horror theme, 5 rooms)
   - "The Crystal Caverns" (exploration theme, 7 rooms)
   - "The Sky Pirates" (adventure theme, 6 rooms)
   - Each with unique items and puzzles
5. Expand command set:
   - `examine <item>` - detailed item descriptions
   - `use <item>` - item interactions (keys, tools)
   - `open <direction>` - locked doors requiring keys
   - `talk <npc>` - NPC conversations (basic)
6. Enhanced parser:
   - Multi-word items ("rusty key", "old book")
   - Synonyms (take/get, drop/put, north/n)
   - Better error messages ("You don't see that here")

DELIVERABLES:
- src/world_loader.c (file parsing)
- src/save_load.c (game persistence)
- worlds/*.world (3 new adventure files)
- Updated parser with enhanced commands
- docs/WORLD-FORMAT.md (file format spec)
- Updated README.md with new features

SUCCESS CRITERIA:
- Worlds load from files (no hardcoded data)
- Save/load works correctly
- 3 playable worlds with unique content
- Enhanced parser handles multi-word items
- Documentation clear for world creators
- Backwards compatible with existing demo
```

---

## 8. my-context: Database Migration Documentation and Performance

```
PROJECT: my-context
GOAL: Document database migration, optimize performance, complete Sprint 3

CONTEXT:
- Database mode (v3.0.0) complete and working
- Migration from file-based to PostgreSQL complete
- Sprint 2 features shipped (export, archive, delete, filtering)
- Production ready, in active use

TASKS:
1. Document database migration:
   - Write docs/DATABASE-MIGRATION.md
   - Explain file-based vs database mode
   - Migration script explanation (if applicable)
   - MY_CONTEXT_HOME=db usage patterns
   - Multi-partition strategy (db:project_name)
2. Performance optimization:
   - Add database indexes for common queries
   - Implement connection pooling if needed
   - Profile slow queries (list --search, export --all)
   - Optimize note/file log loading
   - Benchmark before/after results
3. Sprint 3 feature planning:
   - Review ROADMAP.md for Sprint 3 candidates
   - Implement context tags/labels system
   - Add context templates (project types)
   - Implement context linking (parent/child relationships)
   - Add search by date range
4. Enhanced export:
   - Add export to HTML format
   - Generate activity timeline visualization (ASCII chart)
   - Export filtered sets (by project, date range)
   - Batch export automation script
5. Testing and reliability:
   - Add database migration tests
   - Test concurrent context operations
   - Validate data integrity constraints
   - Test error recovery (DB connection loss)

DELIVERABLES:
- docs/DATABASE-MIGRATION.md
- docs/PERFORMANCE.md (optimization results)
- Database schema optimizations (indexes, queries)
- Sprint 3 feature implementation
- Enhanced export formats
- Comprehensive test suite updates
- Updated README.md with database mode docs

SUCCESS CRITERIA:
- Migration documentation complete
- Performance improved (benchmark data)
- Sprint 3 features working
- All tests passing
- Ready for v3.1.0 release
```

---

## Execution Instructions

### For Each Prompt:

1. **Copy prompt into new Claude Code session** in project directory
2. **Let agent work autonomously** - prompts are self-contained
3. **Review deliverables** when agent completes
4. **Merge or iterate** based on results

### Parallel Execution:

You can run multiple prompts in parallel since projects are independent:
- Start 3-4 sessions simultaneously
- Monitor progress via my-context database (if using)
- Collect results as they complete

### Success Metrics:

- [ ] All deliverables created
- [ ] Tests passing
- [ ] Documentation updated
- [ ] Code follows project conventions
- [ ] PR-ready or directly mergeable

---

## Notes

- Prompts assume ~2-4 hours of agent work time
- All tasks are concrete and measurable
- No external dependencies required
- Results should be immediately useful
- Each moves project significantly forward on roadmap

**Generated by**: Claude Code coordination workspace
**Last Updated**: 2025-11-18
