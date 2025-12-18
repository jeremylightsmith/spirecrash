extends GutTest

## Unit tests for double jump functionality

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var player: Player


func before_each() -> void:
	# Add a floor for the player to land on
	var static_body: StaticBody2D = autofree(StaticBody2D.new())
	static_body.position = Vector2(0, 100)
	var collision: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(1000, 50)
	collision.shape = shape
	static_body.add_child(collision)
	add_child_autofree(static_body)

	# Add player above the floor
	player = autofree(player_scene.instantiate())
	player.player_id = 0
	player.position = Vector2(0, 76)
	add_child_autofree(player)
	await wait_physics_frames(5)


func test_player_starts_with_jumps_after_landing() -> void:
	# Player should have reset jumps after landing on ground
	assert_eq(player.jumps_remaining, player.max_jumps, "Player should have max jumps after landing")


func test_player_has_max_jumps_set_to_two() -> void:
	assert_eq(player.max_jumps, 2, "Player should have max_jumps = 2 for double jump")


func test_reset_jumps_restores_to_max() -> void:
	player.jumps_remaining = 0
	player.reset_jumps()
	assert_eq(player.jumps_remaining, player.max_jumps, "reset_jumps should restore to max_jumps")


func test_can_jump_returns_true_when_jumps_remaining() -> void:
	player.jumps_remaining = 2
	assert_true(player.can_jump(), "can_jump should return true when jumps remaining")


func test_can_jump_returns_false_when_no_jumps() -> void:
	player.jumps_remaining = 0
	assert_false(player.can_jump(), "can_jump should return false when no jumps remaining")


func test_consume_jump_decrements_counter() -> void:
	player.jumps_remaining = 2
	player.consume_jump()
	assert_eq(player.jumps_remaining, 1, "consume_jump should decrement counter")


func test_consume_jump_does_not_go_negative() -> void:
	player.jumps_remaining = 0
	player.consume_jump()
	assert_eq(player.jumps_remaining, 0, "consume_jump should not go below 0")


func test_idle_state_resets_jumps() -> void:
	# Get the idle state
	var idle_state = player.state_machine.states.get("idle")
	assert_not_null(idle_state, "Should have idle state")

	# Set jumps to 0
	player.jumps_remaining = 0

	# Manually call idle state enter (simulates landing)
	idle_state.enter()

	# Jumps should be reset
	assert_eq(player.jumps_remaining, player.max_jumps, "Idle state enter should reset jumps")
