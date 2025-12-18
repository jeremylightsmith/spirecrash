# SpireCrash

A TowerFall Ascension-inspired local multiplayer arena brawler built with Godot 4.x.

## Project Status

**Phase 1: Core Movement** - ✅ Complete

Basic player movement, jumping, and state machine architecture implemented with unit and integration tests.

## Getting Started

### Prerequisites
- Godot 4.x (tested with 4.5)
- GUT (Godot Unit Testing) - included in `addons/gut/`

### Running the Game

1. Open the project in Godot Editor:
   ```bash
   godot --path /path/to/spire-crash
   ```

2. Press **F5** or click **Run Project** to play

### Controls

**Player 1 (Keyboard):**
- Movement: WASD
- Jump: Space
- Shoot: E (Phase 2)
- Dash: Left Shift (Phase 5)

**Player 2 (Keyboard):**
- Movement: Arrow Keys
- Jump: Right Ctrl
- Shoot: Right Alt
- Dash: Right Shift

**Players 3-4:** Controller support

## Running Tests

### Method 1: In Godot Editor (Recommended)

1. Open project in Godot
2. Enable GUT plugin: **Project → Project Settings → Plugins → Gut (Enable)**
3. Go to bottom panel and select **GUT** tab
4. Click **Run All** to run all tests

### Method 2: Command Line

Run the test script:
```bash
cd /Users/jeremy/src/spire-crash
./run_tests.sh
```

Or run directly with Godot:
```bash
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit,res://tests/integration -gexit
```

### Test Structure

```
tests/
├── unit/                          # Unit tests
│   ├── test_state_machine.gd     # State machine tests
│   ├── test_game_manager.gd      # Game manager tests
│   └── test_input_manager.gd     # Input manager tests
└── integration/                   # Integration tests
    └── test_player_movement.gd   # Player movement tests
```

## Project Structure

```
res://
├── scenes/          # Scene files (.tscn)
├── scripts/         # GDScript files (.gd)
│   ├── autoload/    # Singleton scripts
│   ├── player/      # Player-related scripts
│   ├── combat/      # Combat system scripts
│   └── systems/     # Game systems
├── resources/       # Assets (sprites, audio)
├── tests/           # Test files
└── addons/          # Third-party addons
```

## Development

### Current Features (Phase 1)
- ✅ Player movement (walking, running)
- ✅ Jumping with variable height
- ✅ State machine architecture
- ✅ Basic arena with platforms
- ✅ Input system for 2 keyboard players
- ✅ Unit and integration tests

### Upcoming Features
- **Phase 2:** Combat system (arrows, hitboxes)
- **Phase 3:** Multiplayer support (3-4 players)
- **Phase 4:** Match/round system with scoring
- **Phase 5:** Advanced movement (dash, head-stomp)
- **Phase 6:** Arrow mechanics (catching, retrieval)
- **Phase 7:** Multiple arenas, screen wrap
- **Phase 8:** Powerups and special items
- **Phase 9-10:** Polish, effects, replay system

## Architecture

### Autoload Singletons
- **EventBus:** Global signal hub for decoupled communication
- **GameManager:** Match state, scoring, and player tracking
- **InputManager:** Unified input API for multiple players

### State Machine Pattern
Player behavior is managed through a state machine with the following states:
- **Idle:** Standing still on ground
- **Move:** Walking/running on ground
- **Jump:** In the air (jumping or falling)

Each state handles its own logic and transitions.

## Contributing

See `the-plan.md` for the full implementation roadmap and `TODO.md` for current progress.

## License

This is a learning project inspired by TowerFall Ascension.
