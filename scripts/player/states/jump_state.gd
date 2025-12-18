extends State

## Player jump state - in the air
##
## Handles jumping, falling, and air control

var coyote_time: float = 0.1  # Grace period after leaving ground
var jump_buffer_time: float = 0.1  # Input buffer before landing
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0


func enter() -> void:
	if not player:
		return

	# If we just pressed jump, apply jump velocity
	if InputManager.is_jump_pressed(player.player_id):
		player.velocity.y = -player.get("jump_velocity")


func physics_update(delta: float) -> void:
	if not player:
		return

	# Apply gravity
	var gravity: float = player.get("gravity")

	# Variable jump height - release jump for shorter jump
	if player.velocity.y < 0 and not InputManager.is_jump_held(player.player_id):
		player.velocity.y += gravity * delta * 2.0  # Fall faster when releasing jump
	else:
		player.velocity.y += gravity * delta

	# Air control
	var input_dir: Vector2 = InputManager.get_move_input(player.player_id)
	if abs(input_dir.x) > 0.1:
		var air_speed: float = player.get("move_speed") * 0.8  # Reduced air control
		var air_acceleration: float = player.get("acceleration") * 0.5
		player.velocity.x = move_toward(player.velocity.x, input_dir.x * air_speed, air_acceleration * delta)

		# Flip sprite based on direction
		if input_dir.x != 0 and player.has_node("Sprite2D"):
			var sprite: Sprite2D = player.get_node("Sprite2D")
			if sprite:
				sprite.flip_h = input_dir.x < 0

	player.move_and_slide()

	# Check if landed
	if player.is_on_floor():
		if abs(input_dir.x) > 0.1:
			state_machine.transition_to("Move")
		else:
			state_machine.transition_to("Idle")
