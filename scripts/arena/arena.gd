extends Node2D

## Base arena scene
##
## Manages player spawning and arena-specific logic.

@export var player_scene: PackedScene = preload("res://scenes/player/player.tscn")

@onready var spawn_points: Node2D = $SpawnPoints
@onready var camera: Camera2D = $Camera2D

var active_players: Array[Player] = []


func _ready() -> void:
	# Connect to death events for score tracking
	EventBus.player_died.connect(_on_player_died)

	# Register players in GameManager (-1 = keyboard device)
	GameManager.register_player(0, -1)  # Player 1 keyboard
	GameManager.register_player(1, -1)  # Player 2 keyboard

	# Spawn two players for testing
	spawn_player(0, 0)  # Player 1 at first spawn point
	spawn_player(1, 1)  # Player 2 at second spawn point


func spawn_test_player() -> void:
	if spawn_points.get_child_count() == 0:
		push_warning("No spawn points found in arena")
		return

	var spawn_point: Marker2D = spawn_points.get_child(0) as Marker2D
	if not spawn_point:
		return

	var player: Player = player_scene.instantiate()
	player.player_id = 0
	player.global_position = spawn_point.global_position

	add_child(player)
	active_players.append(player)


func spawn_player(player_id: int, spawn_index: int = -1) -> Player:
	if spawn_points.get_child_count() == 0:
		push_warning("No spawn points found in arena")
		return null

	# Use specified spawn point or cycle through them
	var spawn_idx: int = spawn_index if spawn_index >= 0 else player_id % spawn_points.get_child_count()
	var spawn_point: Marker2D = spawn_points.get_child(spawn_idx) as Marker2D

	if not spawn_point:
		return null

	var player: Player = player_scene.instantiate()
	player.player_id = player_id
	player.global_position = spawn_point.global_position

	add_child(player)
	active_players.append(player)

	return player


func clear_players() -> void:
	for player in active_players:
		if is_instance_valid(player):
			player.queue_free()
	active_players.clear()


func get_spawn_point(player_id: int) -> Vector2:
	# Get spawn point for a player
	if spawn_points.get_child_count() == 0:
		return Vector2(800, 450)  # Default center position

	# Cycle through spawn points based on player ID
	var spawn_idx: int = player_id % spawn_points.get_child_count()
	var spawn_point: Marker2D = spawn_points.get_child(spawn_idx) as Marker2D

	if spawn_point:
		return spawn_point.global_position
	else:
		return Vector2(800, 450)


func _on_player_died(player: CharacterBody2D, dead_player_id: int, killer_id: int) -> void:
	# Track score for killer (if not a suicide)
	if killer_id >= 0 and killer_id != dead_player_id:
		GameManager.add_score(killer_id, 1)
		var killer_data = GameManager.get_player_data(killer_id)
		if killer_data:
			print("Player %d killed Player %d. Score: %d" % [killer_id, dead_player_id, killer_data.score])
