# Boxes-Live + my-context Workflow Example

> A complete worked example showing how to use boxes-live for visual planning while tracking context with my-context.

**Created**: 2025-11-25
**Use Case**: Planning a multi-day feature development with visual canvas

---

## Scenario

You're planning to add a new "collaboration mode" feature to boxes-live that allows multiple users to work on the same canvas via network sync. This is a complex feature requiring:

- Network protocol design
- State synchronization logic
- Conflict resolution
- UI updates for multi-user presence

You'll use boxes-live itself to visually plan the architecture while tracking your decisions in my-context.

---

## Session 1: Initial Planning

### Start the Session

```bash
# Set up context tracking
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "boxes-live-collab-planning-2025-11-25"

# Record our goal
my-context note "Goal: Plan collaboration mode architecture for boxes-live"
my-context note "Approach: Use boxes-live canvas to visualize component relationships"
```

### Create Planning Canvas

```bash
# Navigate to boxes-live
cd ~/projects/boxes-live

# Build if needed
make

# Create a new canvas file for our planning
./boxes-live
```

**In boxes-live:**

1. Press `N` to create a new box - title it "COLLAB MODE"
2. Press `N` again - create "Network Layer"
3. Press `N` - create "State Sync"
4. Press `N` - create "Conflict Resolution"
5. Press `N` - create "UI Updates"
6. Arrange boxes visually to show dependencies
7. Press `F2` to save as `collab-plan.canvas`

```bash
# After saving, record what we created
my-context note "Created visual plan canvas: collab-plan.canvas"
my-context note "Components identified: Network Layer, State Sync, Conflict Resolution, UI Updates"
my-context file collab-plan.canvas
```

### Document Initial Decisions

```bash
my-context note "Decision: Use WebSocket for network layer (low latency, bidirectional)"
my-context note "Decision: CRDT-based state sync for conflict-free merging"
my-context note "Decision: Server-authoritative for box positions, client-predictive for UI"
```

### Review the Plan

```bash
# Reload canvas to review
./boxes-live collab-plan.canvas

# Use Tab to cycle through boxes and review each component
# Use 1-7 to color-code by priority (e.g., red=high, green=low)
```

### End Planning Session

```bash
my-context note "Planning session complete - 4 major components identified"
my-context note "Next: Detail the Network Layer component"
my-context stop
```

---

## Session 2: Network Layer Design

### Resume Context

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "boxes-live-collab-network-2025-11-26"

my-context note "Continuing from planning session"
my-context note "Focus: Design Network Layer in detail"
```

### Expand Network Layer on Canvas

```bash
cd ~/projects/boxes-live
./boxes-live collab-plan.canvas
```

**In boxes-live:**

1. Zoom into the "Network Layer" area
2. Create sub-boxes:
   - "WebSocket Client"
   - "Message Protocol"
   - "Connection Manager"
   - "Heartbeat/Keepalive"
3. Color code by complexity (yellow=simple, red=complex)
4. Save with `F2`

```bash
my-context note "Expanded Network Layer: WebSocket Client, Message Protocol, Connection Manager, Heartbeat"
my-context note "Complexity assessment: Message Protocol is most complex (red)"
```

### Document Protocol Design

```bash
my-context note "Protocol messages:
- JOIN: client connects to session
- LEAVE: client disconnects
- BOX_CREATE: new box added
- BOX_MOVE: box position changed
- BOX_DELETE: box removed
- BOX_UPDATE: box properties changed
- SYNC_REQUEST: request full state
- SYNC_RESPONSE: full state dump"

my-context note "Decision: Use JSON for message format (human-readable, easy debugging)"
my-context note "Decision: Include sequence numbers for ordering"
```

### Create Implementation Tasks

```bash
# Create a new canvas for implementation tasks
./boxes-live

# Create task boxes:
# - "PR 1: WebSocket client wrapper"
# - "PR 2: Message serialization"
# - "PR 3: Connection lifecycle"
# - "PR 4: Integration tests"

# Save as collab-network-tasks.canvas
```

```bash
my-context note "Created task breakdown: 4 PRs for network layer"
my-context file collab-network-tasks.canvas
my-context note "Estimate: PR1=4h, PR2=3h, PR3=5h, PR4=4h = 16h total"
```

### End Session

```bash
my-context note "Network layer design complete"
my-context stop
my-context export "boxes-live-collab-network-2025-11-26"
```

---

## Session 3: Implementation

### Start Implementation Session

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "boxes-live-collab-impl-pr1-2025-11-27"

my-context note "Starting PR 1: WebSocket client wrapper"
```

### Reference the Plan

```bash
cd ~/projects/boxes-live

# Open task canvas to see what we're implementing
./boxes-live collab-network-tasks.canvas

# Review the requirements
# Press Tab to select "PR 1: WebSocket client wrapper"
```

### Implement the Feature

```bash
# Create feature branch
git checkout -b feature/collab-websocket-client

# Start implementing
my-context note "Creating src/network/websocket.c"
my-context file src/network/websocket.c

# ... implement the code ...

my-context note "Implemented: ws_connect(), ws_disconnect(), ws_send(), ws_receive()"
my-context note "Decision: Using libwebsockets library for portability"
```

### Update Canvas with Progress

```bash
# Open task canvas
./boxes-live collab-network-tasks.canvas

# Select "PR 1" box and color it green (complete)
# Press 3 for green color
# Save with F2

my-context note "Updated task canvas: PR1 marked complete (green)"
```

### Test and Create PR

```bash
# Build with new code
make clean && make

# Run tests
make test

my-context note "Build successful, all tests pass"

# Commit and push
git add src/network/
git commit -m "feat(network): Add WebSocket client wrapper

- Add ws_connect(), ws_disconnect(), ws_send(), ws_receive()
- Use libwebsockets for cross-platform support
- Add reconnection logic with exponential backoff

Part of collaboration mode feature.

🤖 Generated with Claude Code"

git push -u origin feature/collab-websocket-client

# Create PR
gh pr create --title "feat(network): Add WebSocket client wrapper" \
  --body "Part 1 of collaboration mode - WebSocket client foundation"

my-context note "PR created: #XX - WebSocket client wrapper"
```

### End Session

```bash
my-context note "PR 1 complete, waiting for review"
my-context stop
my-context export "boxes-live-collab-impl-pr1-2025-11-27"
```

---

## Using Canvas for Sprint Planning

### Create Sprint Board

```bash
export MY_CONTEXT_HOME=db:jcaldwell_labs
my-context start "sprint-planning-2025-12-01"

cd ~/projects/boxes-live
./boxes-live
```

**Create sprint board layout:**

1. Create column headers as boxes:
   - "BACKLOG" (left)
   - "IN PROGRESS" (center)
   - "DONE" (right)

2. Create task boxes under BACKLOG:
   - "Fix zoom lag #42"
   - "Add undo support #38"
   - "Improve save format #35"

3. Color by priority:
   - Red = critical
   - Yellow = normal
   - Green = nice-to-have

4. Save as `sprint-2025-12-01.canvas`

### Daily Standup Updates

```bash
# Each morning, update the canvas
./boxes-live sprint-2025-12-01.canvas

# Drag completed tasks to DONE column
# Drag started tasks to IN PROGRESS
# Save changes

my-context note "Standup: Moved #42 to DONE, #38 to IN PROGRESS"
```

### End of Sprint Review

```bash
# Open sprint canvas
./boxes-live sprint-2025-12-01.canvas

# Screenshot or note final state
my-context note "Sprint complete: 8/10 tasks done, 2 carried over"

# Archive the canvas
cp sprint-2025-12-01.canvas archive/sprint-2025-12-01-final.canvas

my-context stop
my-context export "sprint-planning-2025-12-01"
```

---

## Tips for boxes-live + my-context Workflow

### Canvas Organization

1. **One canvas per concern**: Separate planning, tasks, architecture
2. **Color coding**: Establish consistent meaning (red=critical, green=done)
3. **Spatial relationships**: Use position to show dependencies/flow
4. **Regular saves**: F2 after each significant change

### my-context Integration

1. **Always note canvas changes**: `my-context note "Updated X on canvas Y"`
2. **Track canvas files**: `my-context file plan.canvas`
3. **Link decisions to visual**: "See component diagram in arch.canvas"
4. **Export regularly**: Preserve context for future sessions

### Workflow Patterns

| Pattern | boxes-live Use | my-context Use |
|---------|----------------|----------------|
| Planning | Architecture diagram | Record decisions |
| Sprint planning | Kanban board | Track progress |
| Design review | Component layout | Document feedback |
| Debugging | Issue relationships | Track investigation |
| Retrospective | Timeline/flow | Lessons learned |

---

## Example Canvas Files

### architecture.canvas
```
+------------------+     +------------------+
|   Network Layer  |---->|   State Sync     |
+------------------+     +------------------+
        |                        |
        v                        v
+------------------+     +------------------+
| Connection Mgr   |     | Conflict Resolve |
+------------------+     +------------------+
```

### sprint-board.canvas
```
 BACKLOG          IN PROGRESS       DONE
+----------+     +----------+     +----------+
| Task #42 |     | Task #38 |     | Task #35 |
| (red)    |     | (yellow) |     | (green)  |
+----------+     +----------+     +----------+
+----------+
| Task #41 |
| (yellow) |
+----------+
```

---

## Related Documentation

- [boxes-live README](../../boxes-live/README.md)
- [Complete Development Workflow](./COMPLETE-DEV-WORKFLOW.md)
- [my-context Integration Pattern](../MY-CONTEXT-INTEGRATION.md)

---

**Document Version**: 1.0
**Last Updated**: 2025-11-25
