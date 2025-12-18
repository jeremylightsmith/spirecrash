extends GutTest

## Integration tests for player movement and physics

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var player: Player


func before_each() -> void:
	# Add a static floor for the player to stand on
	var static_body: StaticBody2D = autofree(StaticBody2D.new())
	static_body.position = Vector2(0, 200)
	var collision: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(1000, 50)
	collision.shape = shape
	static_body.add_child(collision)
	add_child_autofree(static_body)

	# Add player above the floor
	player = add_child_autofree(player_scene.instantiate())
	player.player_id = 0
	player.position = Vector2(0, 0)
	await wait_physics_frames(5)


func test_player_instantiates_correctly() -> void:
	assert_not_null(player, "Player should instantiate")
	assert_not_null(player.state_machine, "Player should have state machine")


func test_player_has_all_states() -> void:
	assert_true(player.state_machine.states.has("idle"), "Should have idle state")
	assert_true(player.state_machine.states.has("move"), "Should have move state")
	assert_true(player.state_machine.states.has("jump"), "Should have jump state")


func test_player_starts_in_idle_state() -> void:
	assert_eq(player.get_current_state(), "Idle", "Should start in idle state")


func test_player_has_sprite() -> void:
	assert_not_null(player.sprite, "Player should have sprite")


func test_player_has_collision_shape() -> void:
	var collision: CollisionShape2D = player.get_node("CollisionShape2D")
	assert_not_null(collision, "Player should have collision shape")
	assert_not_null(collision.shape, "Collision shape should have a shape")


func test_player_has_correct_color() -> void:
	var expected_color: Color = GameManager.PLAYER_COLORS[0]
	assert_eq(player.sprite.modulate, expected_color, "Player 0 should have red color")


func test_player_gravity_applies() -> void:
	# Start with zero velocity
	player.velocity = Vector2.ZERO
	player.position = Vector2(100, 100)

	# Run physics for a few frames
	await wait_physics_frames(10)

	# Player should have fallen
	assert_gt(player.velocity.y, 0.0, "Player should have positive Y velocity from gravity")


func test_player_falls_with_max_speed() -> void:
	# Set velocity to beyond max fall speed
	player.velocity.y = player.max_fall_speed + 100

	# Run one physics frame
	await wait_physics_frames(1)

	# Velocity should be clamped
	assert_lte(player.velocity.y, player.max_fall_speed, "Fall speed should be clamped to max")
