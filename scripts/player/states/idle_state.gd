extends State

## Player idle state - standing still on the ground


func enter() -> void:
	if player:
		player.reset_jumps()


func physics_update(delta: float) -> void:
	if not player:
		return

	# Apply gravity
	if not player.is_on_floor():
		player.velocity.y += player.get("gravity") * delta
		state_machine.transition_to("Jump")
		return

	# Check for jump input
	if InputManager.is_jump_pressed(player.player_id) and player.can_jump():
		state_machine.transition_to("Jump")
		return

	# Check for movement input
	var input_dir: Vector2 = InputManager.get_move_input(player.player_id)
	if abs(input_dir.x) > 0.1:
		state_machine.transition_to("Move")
		return

	# Apply friction
	player.velocity.x = move_toward(player.velocity.x, 0, player.get("friction") * delta)

	player.move_and_slide()
	player.clamp_velocity()
