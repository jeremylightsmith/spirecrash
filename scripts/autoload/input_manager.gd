extends Node

## Maps player IDs to input devices and provides unified input API
##
## Handles keyboard and controller input for up to 4 players.
## Player 1: WASD + Space + Shift (keyboard)
## Player 2: Arrow keys + Ctrl + Alt (keyboard)
## Players 3-4: Controllers

const MAX_PLAYERS: int = 4

# Device mapping: player_id -> device_id (-1 = keyboard, >= 0 = joypad index)
var player_devices: Dictionary = {}


func _ready() -> void:
	_setup_default_players()


func _setup_default_players() -> void:
	player_devices[0] = -1  # Player 1 on keyboard
	player_devices[1] = -2  # Player 2 on keyboard (different keys)


func register_player(player_id: int, device_id: int) -> void:
	if player_id >= 0 and player_id < MAX_PLAYERS:
		player_devices[player_id] = device_id


func get_move_input(player_id: int) -> Vector2:
	var input_vector: Vector2 = Vector2.ZERO
	var device: int = player_devices.get(player_id, -1)

	if device == -1:  # Player 1 keyboard (WASD)
		input_vector.x = Input.get_axis("p1_left", "p1_right")
		input_vector.y = Input.get_axis("p1_up", "p1_down")
	elif device == -2:  # Player 2 keyboard (Arrows)
		input_vector.x = Input.get_axis("p2_left", "p2_right")
		input_vector.y = Input.get_axis("p2_up", "p2_down")
	else:  # Controller
		input_vector.x = Input.get_joy_axis(device, JOY_AXIS_LEFT_X)
		input_vector.y = Input.get_joy_axis(device, JOY_AXIS_LEFT_Y)

	return input_vector.limit_length(1.0)


func is_jump_pressed(player_id: int) -> bool:
	var device: int = player_devices.get(player_id, -1)

	if device == -1:
		return Input.is_action_just_pressed("p1_jump")
	elif device == -2:
		return Input.is_action_just_pressed("p2_jump")
	else:
		return Input.is_joy_button_pressed(device, JOY_BUTTON_A)


func is_jump_held(player_id: int) -> bool:
	var device: int = player_devices.get(player_id, -1)

	if device == -1:
		return Input.is_action_pressed("p1_jump")
	elif device == -2:
		return Input.is_action_pressed("p2_jump")
	else:
		return Input.is_joy_button_pressed(device, JOY_BUTTON_A)


func is_shoot_pressed(player_id: int) -> bool:
	var device: int = player_devices.get(player_id, -1)

	if device == -1:
		return Input.is_action_just_pressed("p1_shoot")
	elif device == -2:
		return Input.is_action_just_pressed("p2_shoot")
	else:
		return Input.is_joy_button_pressed(device, JOY_BUTTON_X)


func is_dash_pressed(player_id: int) -> bool:
	var device: int = player_devices.get(player_id, -1)

	if device == -1:
		return Input.is_action_just_pressed("p1_dash")
	elif device == -2:
		return Input.is_action_just_pressed("p2_dash")
	else:
		return Input.is_joy_button_pressed(device, JOY_BUTTON_B)


func get_aim_direction(player_id: int) -> Vector2:
	var aim_vector: Vector2 = Vector2.ZERO
	var device: int = player_devices.get(player_id, -1)

	if device == -1 or device == -2:
		aim_vector = get_move_input(player_id)
	else:
		aim_vector.x = Input.get_joy_axis(device, JOY_AXIS_RIGHT_X)
		aim_vector.y = Input.get_joy_axis(device, JOY_AXIS_RIGHT_Y)

	return aim_vector.limit_length(1.0)
