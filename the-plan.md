# TowerFall Clone - Godot 4.x Implementation Plan

## Project Overview

Building a TowerFall Ascension clone in Godot 4.x with GDScript, focusing on Versus Mode (2-4 player local multiplayer). Using placeholder graphics to prioritize gameplay mechanics.

## Project Structure

```
res://
├── scenes/
│   ├── main/
│   │   ├── main.tscn                  # Root scene
│   │   └── main_menu.tscn
│   ├── arena/
│   │   ├── arena.tscn                 # Base arena
│   │   ├── arena_01.tscn              # Specific layouts
│   │   └── tileset.tres
│   ├── player/
│   │   └── player.tscn                # Player character
│   ├── combat/
│   │   ├── arrow.tscn                 # Arrow projectile
│   │   ├── bomb_arrow.tscn
│   │   └── explosion.tscn
│   ├── powerups/
│   │   ├── treasure_chest.tscn
│   │   ├── wings.tscn
│   │   └── shield.tscn
│   └── ui/
│       ├── hud.tscn
│       ├── round_start.tscn
│       └── match_end.tscn
├── scripts/
│   ├── autoload/
│   │   ├── game_manager.gd            # Singleton: match/round state
│   │   ├── input_manager.gd           # Singleton: player input mapping
│   │   └── event_bus.gd               # Singleton: global signals
│   ├── player/
│   │   ├── player_controller.gd
│   │   ├── player_state_machine.gd
│   │   ├── states/
│   │   │   ├── state.gd               # Base state class
│   │   │   ├── idle_state.gd
│   │   │   ├── move_state.gd
│   │   │   ├── jump_state.gd
│   │   │   └── dash_state.gd
│   │   ├── player_combat.gd
│   │   └── player_stats.gd
│   ├── combat/
│   │   ├── arrow.gd
│   │   ├── hitbox.gd
│   │   └── hurtbox.gd
│   └── systems/
│       ├── match_manager.gd
│       └── powerup_spawner.gd
└── resources/
    ├── sprites/
    └── audio/
```

## Core Systems Architecture

### 1. Autoload Singletons

**EventBus (event_bus.gd)**
- Global signal hub for decoupled communication
- Key signals: player_died, player_respawned, arrow_fired, round_started, round_ended

**GameManager (game_manager.gd)**
- Match state and configuration
- Track rounds, scores, active players
- Manage match settings (rounds_to_win, starting_arrows)

**InputManager (input_manager.gd)**
- Maps player IDs to input devices (keyboard vs controllers)
- Provides unified input API for all players
- Critical for multiplayer support

### 2. Player System

**Architecture:**
- CharacterBody2D base (best for platformer physics)
- Component-based design with separate scripts
- State Machine for behavior management

**Player Components:**
- PlayerController: Main coordination
- PlayerInput: Input handling for assigned device
- PlayerCombat: Shooting/catching arrows
- PlayerStats: Arrows, lives, powerups
- StateMachine: Idle, Move, Jump, Dash, Dead states

**State Machine Pattern:**
- Base State class with enter/exit/update methods
- Each state inherits and implements specific behavior
- Clean transitions between states

### 3. Combat System

**Arrow System:**
- RigidBody2D for realistic physics
- States: Flying, Stuck, Retrievable
- Hitbox/Hurtbox pattern for damage
- Catchable mid-flight (advanced mechanic)

**Collision Detection:**
- Hitbox (Area2D): Damage dealer
- Hurtbox (Area2D): Damage receiver
- Clean separation of concerns

### 4. Arena System

**Components:**
- TileMap for platforms and walls
- SpawnPoints for player spawning
- ScreenWrap zones for edge wrapping
- PowerupSpawn points
- Static Camera2D showing full arena

### 5. Match Management

**Flow:**
1. Main Menu → Player Selection
2. Match Start → Initialize scores
3. Round Start → Spawn players, countdown
4. Round Active → Gameplay
5. Round End → Show winner, update scores
6. Check Match Winner → Continue or end match
7. Return to Menu

### 6. Input System

**Mapping:**
- Player 1: WASD + Space (keyboard)
- Player 2: Arrow keys + Ctrl (keyboard)
- Players 3-4: Controllers
- Generic joypad actions for controller support

## Technical Decisions

**Physics:**
- CharacterBody2D for players (precise platformer control)
- RigidBody2D for arrows (realistic physics, catching)
- Area2D for detection (hitboxes, triggers)

**Collision Layers:**
1. Players
2. Arrows
3. Platforms/Walls
4. Hitboxes
5. Hurtboxes
6. Triggers

**Signal Architecture:**
EventBus → GameManager → MatchManager → Arena → Players

## Implementation Phases

### Phase 1: Core Movement (First Priority)
**Goal:** Single player can move, jump in arena

1. Set up project structure and autoloads
2. Create basic arena with TileMap
3. Implement Player scene (CharacterBody2D)
4. Basic movement (walk, jump, gravity)
5. State machine foundation
6. Idle, move, jump states
7. Static camera setup

**Deliverable:** Playable single-player movement

### Phase 2: Combat Basics
**Goal:** Player can shoot arrows that deal damage

1. Create Arrow scene (RigidBody2D)
2. Implement shooting from player
3. Arrow collision and sticking
4. Hitbox/Hurtbox system
5. Player death from hits
6. Simple respawn

**Deliverable:** Functional combat system

### Phase 3: Multiplayer Input
**Goal:** 2 players can play simultaneously

1. Implement InputManager singleton
2. Set up input actions for 2 players
3. Spawn multiple players at spawn points
4. Test 2-player combat
5. Player differentiation (colors)

**Deliverable:** 2-player local multiplayer working

### Phase 4: Match System
**Goal:** Full match flow with rounds and scoring

1. Implement GameManager singleton
2. Create MatchManager
3. Round countdown UI
4. Track alive players
5. Detect round winner
6. Score tracking
7. Match winner detection
8. Round/Match end UI

**Deliverable:** Complete match flow

### Phase 5: Advanced Movement
**Goal:** Dash and head-stomp

1. Dash state implementation
2. Dash invulnerability
3. Dash cooldown
4. Head-stomp detection
5. Head-stomp kills

**Deliverable:** Full movement mechanics

### Phase 6: Arrow Mechanics
**Goal:** Arrow economy and retrieval

1. Arrow retrieval from surfaces
2. Arrow drops from dead players
3. Limited arrow count
4. Arrow catching mid-flight
5. 8-directional aiming

**Deliverable:** Complete arrow system

### Phase 7: Arena Features
**Goal:** Screen wrap and multiple arenas

1. Screen wrap zones
2. Create 2-3 arena layouts
3. Arena selection
4. Test wrap mechanics

**Deliverable:** Multiple playable arenas

### Phase 8: Powerups
**Goal:** Treasure chests and special items

1. Treasure chest system
2. Powerup base class
3. Wings powerup
4. Shield powerup
5. Bomb/laser arrows
6. Random spawning

**Deliverable:** Full powerup system

### Phase 9-10: Polish & Replay
**Goal:** Game feel and instant replay

1. Particle effects
2. Screen shake
3. Sound effects and music
4. Replay recorder
5. Final kill replay

**Deliverable:** Polished complete game

## Critical Files (Implementation Order)

1. **res://scripts/autoload/event_bus.gd** - Set up global signals first
2. **res://scripts/autoload/game_manager.gd** - Central state management
3. **res://scripts/autoload/input_manager.gd** - Multiplayer input foundation
4. **res://scripts/player/state.gd** - Base state class
5. **res://scripts/player/player_state_machine.gd** - State machine architecture
6. **res://scripts/player/player_controller.gd** - Main player logic
7. **res://scripts/combat/arrow.gd** - Arrow behavior
8. **res://scripts/combat/hitbox.gd & hurtbox.gd** - Damage system
9. **res://scenes/arena/arena.tscn** - First test arena
10. **res://scenes/player/player.tscn** - Player scene setup

## Key Godot 4.x Features

- **Typed GDScript:** `var players: Array[Player] = []`
- **@onready:** Clean node references
- **@export:** Designer-friendly variables
- **await:** Clean async code for timers/animations
- **Groups:** Tag and query entities easily
- **PackedScene:** Reusable scene templates

## Development Tips

**Start Simple:**
- Colored rectangles for sprites initially
- Focus on gameplay feel first
- Polish last

**Testing Strategy:**
1. Test single-player first
2. Add multiplayer early to catch issues
3. Test edge cases (0 arrows, simultaneous deaths)
4. Test each arena with wrap

**Common Pitfalls:**
- Set collision layers correctly from start
- Test multiple input devices early
- Disconnect signals when nodes are freed
- Use global_position for spawning
- Always use delta in physics

## Priority Summary

**Must Have (MVP):**
- Player movement and jumping
- Arrow shooting and collision
- Player death/respawn
- 2-4 player support
- Round/match system
- Basic UI

**Should Have:**
- Dash mechanic
- Head-stomp
- Arrow retrieval
- Screen wrap
- Multiple arenas

**Nice to Have:**
- Powerups
- Special arrows
- Instant replay
- Particle effects
- Sound/music

**Target:** Phases 1-4 create a minimum viable game. Build these first, then iterate based on playtesting.
