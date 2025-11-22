# Remaining jcaldwell-labs Project Prompts
**Generated**: 2025-11-18 (Updated)
**Status**: 4 projects already running (adventure-engine-v2, fintrack, smartterm-prototype, boxes-live)
**Remaining**: terminal-stars, tario, my-context

---

## 1. terminal-stars: Space Combat Mode + PR #5 Integration

```
PROJECT: terminal-stars
WORKING DIRECTORY: ~/projects/terminal-stars
GOAL: Implement space combat gameplay mode and integrate horizon feature from PR #5

CURRENT STATE:
- Full implementation exists (not placeholder!)
- Files: main.c, starfield.c, effects.c, input.c, gamepad.c, ship.c, weapons.c, modes.c, render.c
- 6 effects already implemented
- Joystick support working (JOYSTICK-SUCCESS.md confirms)
- PR #5 open: "Add horizon and disable star field"
- Multiple modes already exist in modes.c/modes.h

CONTEXT ANALYSIS:
This is NOT an early-stage project. The codebase shows:
- Comprehensive types.h (9407 bytes) with Game, Ship, Weapon, Mode structures
- Full gamepad integration (gamepad.c 9060 bytes)
- Complex rendering system (render.c 18581 bytes)
- Main.c is substantial (31143 bytes)
- modes.c (20487 bytes) suggests multiple game modes

TASKS:
1. Code Audit and Documentation:
   - Review main.c to understand current game modes
   - Document existing features in FEATURES.md
   - Map out mode system architecture
   - Identify what modes currently exist
   - Check if combat/dogfight mode already implemented

2. Review and Integrate PR #5:
   - Check out PR #5 branch
   - Review horizon rendering implementation
   - Test horizon with existing effects
   - Verify star field disable functionality
   - Merge or request changes as appropriate
   - Update documentation with horizon feature

3. Combat Mode Enhancement (if exists) or Implementation (if missing):
   - Review ship.c and weapons.c current state
   - Implement enemy AI ships if not present
   - Add collision detection for combat
   - Weapon firing and projectile physics
   - Health/shield system
   - Score/kill tracking
   - Wave-based enemy spawning

4. Combat HUD and Feedback:
   - Shield/health display
   - Weapon status (ammo, cooldown)
   - Enemy radar/proximity indicator
   - Score and wave counter
   - Damage feedback (screen shake, color flash)

5. Testing and Polish:
   - Compile and run current build
   - Test all existing modes
   - Verify joystick controls work with combat
   - Performance testing (maintain 60fps)
   - Create gameplay documentation

6. Documentation:
   - Update README.md with all modes
   - Create MODE-GUIDE.md explaining each mode
   - Document combat controls
   - Add screenshots (ASCII art examples)
   - Update CLAUDE.md with current architecture

IMPORTANT DISCOVERY STEP:
Before implementing anything new, you MUST:
1. Compile and run: `make && ./terminal-stars`
2. Explore existing modes and document them
3. Read through main.c to see what's already there
4. Check modes.c to understand mode switching

DELIVERABLES:
- FEATURES.md (comprehensive feature list)
- MODE-GUIDE.md (all modes documented)
- PR #5 reviewed and integrated/commented
- Combat mode working (enhanced or newly implemented)
- Updated README.md and CLAUDE.md
- Test results documented

SUCCESS CRITERIA:
- All existing modes documented
- PR #5 status resolved (merged or feedback given)
- Combat mode playable and fun
- Joystick controls working in combat
- 60fps maintained
- Clear documentation of all features
- No regressions in existing functionality

DISCOVERY BEFORE BUILDING:
This project appears much more mature than the CLAUDE.md suggests.
Spend significant time understanding what already exists before writing new code.
```

---

## 2. tario: Complete Platformer Physics and First Level

```
PROJECT: tario
WORKING DIRECTORY: ~/projects/tario
GOAL: Finish core platformer mechanics and create playable first level

CURRENT STATE:
- Basic structure exists with 6 source files
- Files: main.c (568 bytes), game.c (4512 bytes), level.c, player.c, render.c, terminal.c
- Headers exist for all modules
- Makefile builds successfully
- Binary exists (22272 bytes) and is executable
- Early implementation stage but foundation laid

CONTEXT:
The project has skeleton code but needs fleshing out:
- Terminal handling implemented (terminal.c/h)
- Game loop structure exists (game.c/h)
- Player and level modules started but minimal
- Rendering primitives likely stubbed

TASKS:
1. Audit Current Implementation:
   - Run ./tario to see current state
   - Review game.c game loop implementation
   - Check what terminal.c provides (ANSI codes, raw mode?)
   - Examine player.c for existing physics
   - Review level.c tile system

2. Complete Terminal Rendering System:
   - ANSI escape code utilities (clear, cursor, color)
   - Double buffering implementation
   - Screen dimensions detection
   - Color palette setup (8-16 colors)
   - Box drawing characters for tiles

3. Implement Player Physics:
   - Position (x, y) with subpixel precision (fixed-point or float)
   - Velocity (vx, vy) with gravity constant
   - Acceleration and friction
   - Jump mechanics:
     - Variable jump height (hold longer = higher)
     - Coyote time (late jump forgiveness)
     - Jump buffering (early jump input)
   - Collision detection:
     - Tile-based collision (solid blocks)
     - Slopes/ramps (optional for MVP)
     - One-way platforms

4. Create Tile System:
   - Tile types: Air, Solid, Spike, Goal, Platform
   - Tile rendering with ASCII art
   - Level data structure (2D array)
   - Level scrolling (camera follows player)
   - Viewport culling (only render visible tiles)

5. Design First Level:
   - Tutorial section (learn jump, move)
   - Easy platforming challenge
   - Introduce hazards (spikes)
   - Collectibles (coins/stars) - optional
   - Goal/exit flag
   - 20-30 screens wide, 3-4 screens tall

6. Game Loop and Timing:
   - Fixed timestep (60fps target)
   - Input handling (arrow keys, WASD, Space)
   - Update physics
   - Render pipeline
   - Frame timing with nanosleep()

7. Player Animation:
   - Idle sprite
   - Walk cycle (2-3 frames)
   - Jump/fall sprite
   - Death animation
   - Direction facing (flip sprite)

8. Basic Game Features:
   - Lives system (3 lives)
   - Death and respawn (checkpoint or level start)
   - Victory screen (reach goal)
   - Simple HUD (lives, score if applicable)
   - Pause menu (P key)

9. Polish:
   - Sound effects placeholders (visual feedback for jumps, death)
   - Particle effects (death burst, landing dust) - ASCII art
   - Screen shake on death
   - Smooth camera movement

DELIVERABLES:
- Completed player.c with full physics
- Completed level.c with tile system and first level
- render.c with double buffering and ANSI rendering
- game.c with complete game loop
- Playable first level
- Updated README.md with controls and gameplay
- GAMEPLAY.md with mechanics documentation

SUCCESS CRITERIA:
- Game runs smoothly at 60fps
- Player movement feels responsive
- Jump mechanics work with coyote time and buffering
- First level is completable and fun
- No memory leaks (valgrind clean)
- Clean exit on Q/ESC
- Documentation clear for players and developers

TESTING CHECKLIST:
- [ ] Player can move left/right
- [ ] Jump height varies with button hold time
- [ ] Gravity feels natural
- [ ] Collision with platforms works
- [ ] Death and respawn functions
- [ ] Level goal triggers victory
- [ ] Camera follows player smoothly
- [ ] Terminal resize handled gracefully
```

---

## 3. my-context: Sprint 3 Features + Production Hardening

```
PROJECT: my-context
WORKING DIRECTORY: ~/projects/my-context
GOAL: Implement Sprint 3 features and production hardening for wider release

CURRENT STATE:
- Production ready, in active use
- Database mode (v3.0.0) complete
- Recent commits show FinTrack separation and foundation work
- Sprint 2 complete (export, archive, delete, filtering)
- Cross-platform Go CLI tool

CONTEXT:
This is a mature, production tool. Focus should be on:
- New high-value features
- Performance and reliability
- Documentation for new users
- Release preparation

TASKS:
1. Sprint 3 Feature: Context Tags/Labels
   - Add `tags` field to context metadata
   - Implement `my-context tag add <context> <tag>`
   - Implement `my-context tag remove <context> <tag>`
   - Filter contexts by tag: `my-context list --tag <tag>`
   - Multiple tags support (comma-separated)
   - Tag autocomplete suggestions
   - Update database schema for tags

2. Sprint 3 Feature: Context Templates
   - Define common context templates (bug-fix, feature, meeting, research)
   - `my-context start "Fix login" --template bug-fix`
   - Templates include:
     - Pre-filled note prompts
     - Suggested tags
     - Default file associations
   - User-defined templates in ~/.my-context/templates/
   - Template listing: `my-context template list`

3. Sprint 3 Feature: Parent-Child Context Relationships
   - Link contexts: `my-context link <child> <parent>`
   - Show context tree: `my-context tree <parent>`
   - Useful for sprint -> task -> subtask hierarchy
   - Export includes parent context reference
   - Navigation: `my-context up` (go to parent), `my-context down` (list children)

4. Enhanced Search:
   - Search by date range: `my-context list --from 2025-11-01 --to 2025-11-18`
   - Search in notes content: `my-context search "bug fix"`
   - Search by file association: `my-context list --file "src/main.go"`
   - Full-text search across all contexts
   - Search results highlighting

5. Performance Optimization:
   - Add database indexes for common queries
   - Profile slow operations (export --all, list --search)
   - Implement query result caching
   - Optimize note/file log loading
   - Connection pool configuration
   - Benchmark suite (before/after metrics)

6. Reliability and Error Handling:
   - Database connection retry logic
   - Graceful degradation if DB unavailable
   - Data integrity validation
   - Atomic operations for critical updates
   - Comprehensive error messages
   - Logging system for debugging

7. Multi-Database Backend Support:
   - Abstract database interface
   - PostgreSQL (current)
   - SQLite support (lightweight option)
   - MySQL support (optional)
   - Auto-detect and configure based on MY_CONTEXT_HOME

8. Documentation Expansion:
   - docs/SPRINT-3-FEATURES.md
   - docs/PERFORMANCE.md (optimization results)
   - docs/ARCHITECTURE.md (system design)
   - docs/DATABASE.md (schema, migrations, backends)
   - Update README.md with Sprint 3 features
   - Create video tutorials (script format in docs/)

9. Release Preparation:
   - Bump version to v3.1.0
   - Update CHANGELOG.md
   - Create release notes
   - Build binaries for all platforms
   - Test cross-platform installation
   - GitHub Actions CI/CD setup (optional)

10. Community Features:
    - CONTRIBUTING.md with development guide
    - Issue templates for bugs/features
    - PR template
    - Code of conduct
    - Example contexts repository

DELIVERABLES:
- Tags/labels system implemented
- Context templates working
- Parent-child relationships functional
- Enhanced search capabilities
- Performance benchmarks showing improvements
- Reliability improvements with error handling
- Multi-database backend support (at least SQLite + PostgreSQL)
- Comprehensive documentation updates
- v3.1.0 release ready

SUCCESS CRITERIA:
- All Sprint 3 features working and tested
- Performance improved by measurable amount (>20% for common ops)
- No data loss scenarios in error cases
- SQLite backend works for single-user scenarios
- Documentation complete and clear
- Ready for public v3.1.0 release
- All tests passing (unit + integration)

TESTING REQUIREMENTS:
- [ ] Tags can be added/removed/filtered
- [ ] Templates create contexts correctly
- [ ] Parent-child linking works bidirectionally
- [ ] Date range search accurate
- [ ] Full-text search finds relevant contexts
- [ ] SQLite backend functional
- [ ] Performance benchmarks show improvement
- [ ] Error scenarios handled gracefully
- [ ] Cross-platform builds successful

BACKWARD COMPATIBILITY:
- Must maintain compatibility with existing contexts
- Migration path from v3.0.0 to v3.1.0
- Database schema migrations automated
- No breaking CLI changes
```

---

## Execution Notes

### terminal-stars
- **Key**: This project is MORE COMPLETE than documented
- **Approach**: Discovery-first, then enhancement
- **Risk**: Don't rewrite existing working code
- **Opportunity**: Document and showcase existing features

### tario
- **Key**: Early stage, needs core implementation
- **Approach**: Complete the physics engine first
- **Risk**: Physics feel is critical for platformers
- **Opportunity**: Build something truly fun to play

### my-context
- **Key**: Production tool, quality matters
- **Approach**: Feature-complete Sprint 3, then harden
- **Risk**: Don't break existing workflows
- **Opportunity**: Position for wider adoption

---

## Parallel Execution Strategy

Since 4 projects are already running, you can:
1. Start all 3 remaining projects in parallel
2. Monitor progress across all 7 active sessions
3. Review and integrate results as they complete

**Total Active Sessions**: 7 out of 8 jcaldwell-labs projects
**Only Remaining**: atari-style (needs separate handling due to outdated state)

---

**Generated by**: Claude Code coordination workspace
**Last Updated**: 2025-11-18
