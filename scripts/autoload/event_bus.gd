extends Node

## Global signal hub for decoupled communication throughout the game
##
## This singleton provides a central location for game-wide signals,
## allowing systems to communicate without direct dependencies.

# Player signals
signal player_spawned(player: CharacterBody2D, player_id: int)
signal player_died(player: CharacterBody2D, player_id: int, killer_id: int)
signal player_respawned(player: CharacterBody2D, player_id: int)

# Combat signals
signal arrow_fired(arrow: RigidBody2D, shooter_id: int)
signal arrow_caught(arrow: RigidBody2D, catcher_id: int)
signal arrow_stuck(arrow: RigidBody2D, position: Vector2)

# Match/Round signals
signal match_started(player_count: int)
signal match_ended(winner_id: int)
signal round_started(round_number: int)
signal round_ended(winner_id: int, scores: Dictionary)
signal countdown_tick(seconds_remaining: int)

# Powerup signals
signal powerup_spawned(powerup: Node2D, type: String)
signal powerup_collected(powerup: Node2D, collector_id: int, type: String)

# UI signals
signal score_updated(player_id: int, new_score: int)
signal hud_message(message: String, duration: float)
