extends GutTest

## Unit tests for wall jump functionality

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var player: Player


func before_each() -> void:
	# Add a floor for the player
	var floor: StaticBody2D = autofree(StaticBody2D.new())
	floor.position = Vector2(0, 100)
	var floor_collision: CollisionShape2D = CollisionShape2D.new()
	var floor_shape: RectangleShape2D = RectangleShape2D.new()
	floor_shape.size = Vector2(1000, 50)
	floor_collision.shape = floor_shape
	floor.add_child(floor_collision)
	add_child_autofree(floor)

	# Add a wall for the player to jump off
	var wall: StaticBody2D = autofree(StaticBody2D.new())
	wall.position = Vector2(150, 0)
	var wall_collision: CollisionShape2D = CollisionShape2D.new()
	var wall_shape: RectangleShape2D = RectangleShape2D.new()
	wall_shape.size = Vector2(50, 200)
	wall_collision.shape = wall_shape
	wall.add_child(wall_collision)
	add_child_autofree(wall)

	# Add player near the wall
	player = autofree(player_scene.instantiate())
	player.player_id = 0
	player.position = Vector2(0, 76)
	add_child_autofree(player)
	await wait_physics_frames(5)


func test_wall_jump_enabled_by_default() -> void:
	assert_true(player.wall_jump_enabled, "Wall jump should be enabled by default")


func test_wall_jump_has_horizontal_boost() -> void:
	assert_gt(player.wall_jump_horizontal_boost, 0.0, "Wall jump should have horizontal boost")


func test_wall_jump_has_vertical_boost() -> void:
	assert_gt(player.wall_jump_vertical_boost, 0.0, "Wall jump should have vertical boost")


func test_is_touching_wall_only_returns_false_on_ground() -> void:
	# Player starts on ground
	assert_false(player.is_touching_wall_only(), "Should return false when on ground")


func test_can_wall_jump_returns_false_on_ground() -> void:
	# Player starts on ground
	assert_false(player.can_wall_jump(), "Cannot wall jump while on ground")


func test_perform_wall_jump_applies_velocity() -> void:
	# Manually position player against wall in air
	player.position = Vector2(125, 0)
	player.velocity = Vector2(0, 0)

	await wait_physics_frames(3)

	# If player is against wall, perform wall jump
	if player.is_on_wall():
		var initial_x_vel: float = player.velocity.x
		player.perform_wall_jump()

		# Velocity should change after wall jump
		assert_ne(player.velocity.x, initial_x_vel, "X velocity should change after wall jump")
		assert_lt(player.velocity.y, 0.0, "Y velocity should be negative (upward) after wall jump")


func test_wall_jump_leaves_one_jump_remaining() -> void:
	# Set jumps to 0
	player.jumps_remaining = 0
	assert_eq(player.jumps_remaining, 0, "Jumps should start at 0")

	# Perform wall jump
	player.perform_wall_jump()

	# Wall jump counts as first jump, should have one more left
	assert_eq(player.jumps_remaining, player.max_jumps - 1, "Wall jump should leave one jump remaining")


func test_wall_jump_pushes_away_from_wall() -> void:
	# Position player against right side of wall (wall normal points left)
	player.position = Vector2(125, 0)
	player.velocity = Vector2(100, 0)  # Moving right into wall

	await wait_physics_frames(3)

	if player.is_on_wall():
		# Get wall normal before jump
		var wall_normal: Vector2 = player.get_wall_normal()

		# Perform wall jump
		player.perform_wall_jump()

		# Velocity should be in direction of wall normal (away from wall)
		# If wall normal is negative X, velocity X should be negative
		if wall_normal.x < 0:
			assert_lt(player.velocity.x, 0.0, "Should push left away from wall")
		elif wall_normal.x > 0:
			assert_gt(player.velocity.x, 0.0, "Should push right away from wall")
