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

	# If we just pressed jump and have jumps remaining, apply jump velocity
	if InputManager.is_jump_pressed(player.player_id) and player.can_jump():
		player.velocity.y = -player.get("jump_velocity")
		player.consume_jump()


func physics_update(delta: float) -> void:
	if not player:
		return

	# Check for shoot input
	if InputManager.is_shoot_pressed(player.player_id):
		player.shoot_arrow()

	# Check for wall jump (highest priority)
	if InputManager.is_jump_pressed(player.player_id) and player.can_wall_jump():
		player.perform_wall_jump()
		return  # Skip rest of physics this frame for cleaner wall jump

	# Check for double jump (jump pressed while already in air)
	if InputManager.is_jump_pressed(player.player_id) and player.can_jump():
		player.velocity.y = -player.get("jump_velocity")
		player.consume_jump()
		return  # Skip gravity this frame for cleaner double jump

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
		# Update facing direction based on movement
		player.update_facing_direction(input_dir)

		var air_speed: float = player.get("move_speed") * 0.8  # Reduced air control
		var air_acceleration: float = player.get("acceleration") * 0.5
		player.velocity.x = move_toward(player.velocity.x, input_dir.x * air_speed, air_acceleration * delta)

		# Flip sprite based on direction
		if input_dir.x != 0 and player.has_node("Sprite2D"):
			var sprite: Sprite2D = player.get_node("Sprite2D")
			if sprite:
				sprite.flip_h = input_dir.x < 0

	player.move_and_slide()
	player.clamp_velocity()

	# Check if landed
	if player.is_on_floor():
		if abs(input_dir.x) > 0.1:
			state_machine.transition_to("Move")
		else:
			state_machine.transition_to("Idle")
