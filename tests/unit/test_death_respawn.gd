extends GutTest

## Unit tests for death and respawn mechanics

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var arena_scene: PackedScene = preload("res://scenes/arena/arena.tscn")
var player: Player
var arena: Node2D


func before_each() -> void:
	# Create arena with spawn points
	arena = autofree(arena_scene.instantiate())
	add_child_autofree(arena)
	await wait_physics_frames(3)

	# Get the test player spawned by arena
	if arena.active_players.size() > 0:
		player = arena.active_players[0]
	else:
		# Fallback: create player manually
		var floor: StaticBody2D = autofree(StaticBody2D.new())
		floor.position = Vector2(0, 100)
		var floor_collision: CollisionShape2D = CollisionShape2D.new()
		var floor_shape: RectangleShape2D = RectangleShape2D.new()
		floor_shape.size = Vector2(1000, 50)
		floor_collision.shape = floor_shape
		floor.add_child(floor_collision)
		add_child_autofree(floor)

		player = autofree(player_scene.instantiate())
		player.player_id = 0
		player.position = Vector2(0, 76)
		add_child_autofree(player)

	await wait_physics_frames(5)


func test_player_starts_alive() -> void:
	assert_false(player.is_dead, "Player should start alive")


func test_player_starts_visible() -> void:
	assert_true(player.visible, "Player should start visible")


func test_die_makes_player_invisible() -> void:
	player.die()
	await wait_physics_frames(1)
	assert_false(player.visible, "Dead player should be invisible")


func test_die_sets_is_dead_flag() -> void:
	player.die()
	await wait_physics_frames(1)
	assert_true(player.is_dead, "Die should set is_dead flag")


func test_die_stops_velocity() -> void:
	player.velocity = Vector2(100, 100)
	player.die()
	await wait_physics_frames(1)
	assert_eq(player.velocity, Vector2.ZERO, "Die should stop all velocity")


func test_die_disables_collision() -> void:
	player.die()
	await wait_physics_frames(1)
	# Check collision layer and mask are disabled
	assert_false(player.get_collision_layer_value(1), "Collision layer should be disabled")
	assert_false(player.get_collision_mask_value(1), "Collision mask should be disabled")


func test_respawn_timer_starts_on_death() -> void:
	player.die()
	await wait_physics_frames(1)
	assert_gt(player.respawn_timer, 0.0, "Respawn timer should start after death")


func test_respawn_makes_player_visible() -> void:
	player.die()
	await wait_physics_frames(1)
	player.respawn()
	await wait_physics_frames(1)
	assert_true(player.visible, "Respawned player should be visible")


func test_respawn_clears_is_dead_flag() -> void:
	player.die()
	await wait_physics_frames(1)
	player.respawn()
	await wait_physics_frames(1)
	assert_false(player.is_dead, "Respawn should clear is_dead flag")


func test_respawn_resets_velocity() -> void:
	player.velocity = Vector2(100, 100)
	player.respawn()
	# Velocity should be near zero (gravity may apply minimal velocity in one frame)
	assert_lt(abs(player.velocity.x), 1.0, "X velocity should be near zero after respawn")
	assert_lt(abs(player.velocity.y), 20.0, "Y velocity should be near zero after respawn (allowing for gravity)")


func test_respawn_resets_jumps() -> void:
	player.jumps_remaining = 0
	player.respawn()
	await wait_physics_frames(1)
	assert_eq(player.jumps_remaining, player.max_jumps, "Respawn should reset jumps")


func test_respawn_resets_arrows() -> void:
	player.arrows_remaining = 0
	player.respawn()
	await wait_physics_frames(1)
	assert_eq(player.arrows_remaining, player.max_arrows, "Respawn should reset arrows")


func test_respawn_enables_collision() -> void:
	player.die()
	await wait_physics_frames(1)
	player.respawn()
	await wait_physics_frames(1)
	assert_true(player.get_collision_layer_value(1), "Collision layer should be re-enabled")
	assert_true(player.get_collision_mask_value(1), "Collision mask should be re-enabled")


func test_player_died_event_triggers_death() -> void:
	assert_false(player.is_dead, "Player should start alive")
	EventBus.player_died.emit(player, player.player_id, 1)
	await wait_physics_frames(1)
	assert_true(player.is_dead, "Player should die from event")


func test_automatic_respawn_after_delay() -> void:
	player.respawn_delay = 0.5  # Shorter delay for test
	player.die()
	await wait_physics_frames(1)
	assert_true(player.is_dead, "Player should be dead initially")

	# Wait for respawn delay
	await get_tree().create_timer(0.6).timeout
	assert_false(player.is_dead, "Player should respawn after delay")


func test_arena_has_spawn_points() -> void:
	var spawn_point: Vector2 = arena.get_spawn_point(0)
	assert_ne(spawn_point, Vector2.ZERO, "Arena should have spawn points")


func test_get_spawn_point_cycles_by_player_id() -> void:
	var spawn_0: Vector2 = arena.get_spawn_point(0)
	var spawn_1: Vector2 = arena.get_spawn_point(1)
	# Spawn points should be different (unless there's only one)
	if arena.spawn_points.get_child_count() > 1:
		assert_ne(spawn_0, spawn_1, "Different player IDs should get different spawn points")
