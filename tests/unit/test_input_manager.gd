extends GutTest

## Unit tests for InputManager singleton


func test_player_devices_initialized() -> void:
	assert_true(InputManager.player_devices.has(0), "Should have player 0 registered")
	assert_true(InputManager.player_devices.has(1), "Should have player 1 registered")
	assert_eq(InputManager.player_devices[0], -1, "Player 0 should use keyboard device -1")
	assert_eq(InputManager.player_devices[1], -2, "Player 1 should use keyboard device -2")


func test_register_player() -> void:
	InputManager.register_player(2, 0)

	assert_true(InputManager.player_devices.has(2), "Should have player 2 registered")
	assert_eq(InputManager.player_devices[2], 0, "Player 2 should use joypad device 0")


func test_get_move_input_returns_vector2() -> void:
	var input: Vector2 = InputManager.get_move_input(0)
	assert_typeof(input, TYPE_VECTOR2, "Should return Vector2")


func test_get_aim_direction_returns_vector2() -> void:
	var aim: Vector2 = InputManager.get_aim_direction(0)
	assert_typeof(aim, TYPE_VECTOR2, "Should return Vector2")


func test_is_jump_pressed_returns_bool() -> void:
	var jump_pressed: bool = InputManager.is_jump_pressed(0)
	assert_typeof(jump_pressed, TYPE_BOOL, "Should return bool")


func test_is_shoot_pressed_returns_bool() -> void:
	var shoot_pressed: bool = InputManager.is_shoot_pressed(0)
	assert_typeof(shoot_pressed, TYPE_BOOL, "Should return bool")


func test_is_dash_pressed_returns_bool() -> void:
	var dash_pressed: bool = InputManager.is_dash_pressed(0)
	assert_typeof(dash_pressed, TYPE_BOOL, "Should return bool")
