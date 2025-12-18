extends GutTest

## Unit tests for combat mechanics (shooting arrows)

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var arrow_scene: PackedScene = preload("res://scenes/arrow/arrow.tscn")
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

	# Add player
	player = autofree(player_scene.instantiate())
	player.player_id = 0
	player.position = Vector2(0, 76)
	add_child_autofree(player)
	await wait_physics_frames(5)


func test_player_starts_with_arrows() -> void:
	assert_eq(player.arrows_remaining, player.max_arrows, "Player should start with max arrows")


func test_player_has_max_arrows_set() -> void:
	assert_eq(player.max_arrows, 3, "Player should have 3 arrows by default")


func test_can_shoot_arrow_returns_true_with_arrows() -> void:
	assert_true(player.can_shoot_arrow(), "Should be able to shoot with arrows")


func test_can_shoot_arrow_returns_false_without_arrows() -> void:
	player.arrows_remaining = 0
	player.can_shoot = true
	assert_false(player.can_shoot_arrow(), "Should not be able to shoot without arrows")


func test_can_shoot_arrow_returns_false_during_cooldown() -> void:
	player.arrows_remaining = 3
	player.can_shoot = false
	assert_false(player.can_shoot_arrow(), "Should not be able to shoot during cooldown")


func test_shoot_arrow_consumes_arrow() -> void:
	var initial_arrows: int = player.arrows_remaining
	player.shoot_arrow()
	await wait_physics_frames(1)
	assert_eq(player.arrows_remaining, initial_arrows - 1, "Shooting should consume one arrow")


func test_shoot_arrow_spawns_arrow() -> void:
	var initial_child_count: int = player.get_parent().get_child_count()
	player.shoot_arrow()
	await wait_physics_frames(1)
	assert_gt(player.get_parent().get_child_count(), initial_child_count, "Arrow should be spawned")


func test_shoot_arrow_starts_cooldown() -> void:
	player.shoot_arrow()
	await wait_physics_frames(1)
	assert_false(player.can_shoot, "Cooldown should start after shooting")


func test_shoot_cooldown_expires() -> void:
	player.shoot_arrow()
	await wait_physics_frames(1)
	assert_false(player.can_shoot, "Cooldown active")

	# Wait for cooldown to expire (0.3 seconds + buffer)
	await get_tree().create_timer(0.4).timeout
	assert_true(player.can_shoot, "Cooldown should expire after time")


func test_update_facing_direction() -> void:
	var initial_direction: Vector2 = player.facing_direction
	player.update_facing_direction(Vector2.LEFT)
	assert_ne(player.facing_direction, initial_direction, "Facing direction should update")
	assert_eq(player.facing_direction, Vector2.LEFT, "Should face left")


func test_add_arrow_increases_count() -> void:
	player.arrows_remaining = 1
	player.add_arrow()
	assert_eq(player.arrows_remaining, 2, "Adding arrow should increase count")


func test_add_arrow_respects_max() -> void:
	player.arrows_remaining = player.max_arrows
	player.add_arrow()
	assert_eq(player.arrows_remaining, player.max_arrows, "Cannot exceed max arrows")


func test_arrow_has_correct_properties() -> void:
	var arrow: Arrow = autofree(arrow_scene.instantiate())
	add_child_autofree(arrow)
	await wait_physics_frames(1)

	assert_eq(arrow.speed, 600.0, "Arrow should have correct speed")
	assert_eq(arrow.damage, 1, "Arrow should have correct damage")
	assert_false(arrow.stuck, "Arrow should not start stuck")


func test_arrow_launch_sets_velocity() -> void:
	var arrow: Arrow = autofree(arrow_scene.instantiate())
	add_child_autofree(arrow)
	await wait_physics_frames(1)

	arrow.launch(Vector2.RIGHT, 0)
	await wait_physics_frames(1)

	assert_gt(arrow.linear_velocity.length(), 0.0, "Arrow should have velocity after launch")


func test_arrow_rotation_matches_direction() -> void:
	var arrow: Arrow = autofree(arrow_scene.instantiate())
	add_child_autofree(arrow)
	await wait_physics_frames(1)

	arrow.launch(Vector2.RIGHT, 0)
	await wait_physics_frames(1)

	assert_almost_eq(arrow.rotation, 0.0, 0.1, "Arrow should rotate to face right")
