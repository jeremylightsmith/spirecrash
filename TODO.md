# SpireCrash - Phase 1 Implementation TODO

## Phase 1: Core Movement

### Completed ✓
- [x] Set up project structure (folders for scenes, scripts, resources)
- [x] Create autoload singletons (EventBus, GameManager, InputManager)
- [x] Configure input actions for 2 players (P1: WASD+E+Shift, P2: Arrows+RCtrl+RAlt)
- [x] Set up GUT testing framework
- [x] Create base State class and state machine
- [x] Implement player states (Idle, Move, Jump)
- [x] Create Player scene and controller
- [x] Create basic arena with TileMap
- [x] Write tests for state machine and movement logic

### In Progress 🔄
- [ ] Test single-player movement in arena (needs Godot editor)

### Ready to Test 🎮
- Open project in Godot 4.x editor
- Press F5 or click "Run Project" to test movement
- Controls: WASD to move, Space to jump

## Files Created

### Core Systems
- `scripts/autoload/event_bus.gd` - Global signal hub
- `scripts/autoload/game_manager.gd` - Match state management
- `scripts/autoload/input_manager.gd` - Player input handling

### Player System
- `scripts/player/states/state.gd` - Base state class
- `scripts/player/states/idle_state.gd` - Idle state
- `scripts/player/states/move_state.gd` - Movement state
- `scripts/player/states/jump_state.gd` - Jump/air state
- `scripts/player/player_state_machine.gd` - State machine
- `scripts/player/player_controller.gd` - Main player controller
- `scenes/player/player.tscn` - Player scene

### Arena
- `scripts/arena/arena.gd` - Arena manager
- `scenes/arena/arena.tscn` - Test arena with platforms

### Tests
- `tests/unit/test_state_machine.gd` - State machine tests
- `tests/unit/test_game_manager.gd` - GameManager tests
- `tests/unit/test_input_manager.gd` - InputManager tests
- `tests/integration/test_player_movement.gd` - Player integration tests

### Configuration
- `project.godot` - Updated with autoloads, input actions, and GUT plugin
- `.gutconfig.json` - GUT test configuration

## Running Tests

### Option 1: Godot Editor
1. Open project: `godot project.godot`
2. Enable plugin: Project → Project Settings → Plugins → Gut (Enable)
3. Click GUT tab in bottom panel
4. Click "Run All"

### Option 2: Command Line
```bash
./run_tests.sh
```

## Next Steps
1. Open project in Godot editor
2. Enable GUT plugin (if not auto-enabled)
3. Run tests via GUT panel or `./run_tests.sh`
4. Test movement in-game (F5)
5. Add placeholder sprites/visuals
6. Proceed to Phase 2: Combat Basics
