extends Node2D

## Base arena scene
##
## Manages player spawning and arena-specific logic.

@export var player_scene: PackedScene = preload("res://scenes/player/player.tscn")

@onready var spawn_points: Node2D = $SpawnPoints
@onready var camera: Camera2D = $Camera2D

var active_players: Array[Player] = []


func _ready() -> void:
	# Spawn test player at first spawn point
	spawn_test_player()


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
