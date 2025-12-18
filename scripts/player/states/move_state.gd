extends State

## Player move state - walking/running on the ground


func enter() -> void:
	if player:
		player.reset_jumps()


func physics_update(delta: float) -> void:
	if not player:
		return

	# Don't process input if dead
	if player.is_dead:
		return

	# Check for shoot input
	if InputManager.is_shoot_pressed(player.player_id):
		player.shoot_arrow()

	# Apply gravity
	if not player.is_on_floor():
		state_machine.transition_to("Jump")
		return

	# Check for jump input
	if InputManager.is_jump_pressed(player.player_id) and player.can_jump():
		state_machine.transition_to("Jump")
		return

	# Get movement input
	var input_dir: Vector2 = InputManager.get_move_input(player.player_id)

	# Check if stopped moving
	if abs(input_dir.x) < 0.1:
		state_machine.transition_to("Idle")
		return

	# Update facing direction based on movement
	player.update_facing_direction(input_dir)

	# Apply movement
	var speed: float = player.get("move_speed")
	var acceleration: float = player.get("acceleration")

	player.velocity.x = move_toward(player.velocity.x, input_dir.x * speed, acceleration * delta)

	# Flip sprite based on direction
	if input_dir.x != 0 and player.has_node("Sprite2D"):
		var sprite: Sprite2D = player.get_node("Sprite2D")
		if sprite:
			sprite.flip_h = input_dir.x < 0

	player.move_and_slide()
	player.clamp_velocity()
