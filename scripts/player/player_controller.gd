class_name Player
extends CharacterBody2D

## Main player controller
##
## Handles player physics parameters and coordinates with the state machine.

@export var player_id: int = 0

# Movement parameters
@export var move_speed: float = 200.0
@export var acceleration: float = 2000.0
@export var friction: float = 1500.0

# Jump parameters
@export var jump_velocity: float = 400.0
@export var gravity: float = 980.0
@export var max_fall_speed: float = 500.0
@export var max_jumps: int = 2  # 1 = single jump, 2 = double jump, etc.

# Wall jump parameters
@export var wall_jump_enabled: bool = true
@export var wall_jump_horizontal_boost: float = 250.0
@export var wall_jump_vertical_boost: float = 400.0

# Jump state tracking
var jumps_remaining: int = 0

# State machine reference
@onready var state_machine: PlayerStateMachine = get_node_or_null("StateMachine")
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")


func _ready() -> void:
	# Set player color based on ID
	if sprite:
		# Assign placeholder texture if none exists
		if not sprite.texture:
			var placeholder: ImageTexture = _create_placeholder_texture()
			sprite.texture = placeholder

		sprite.modulate = GameManager.get_player_color(player_id)

	# Emit spawn signal
	EventBus.player_spawned.emit(self, player_id)


func _create_placeholder_texture() -> ImageTexture:
	var image: Image = Image.create(32, 48, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	return ImageTexture.create_from_image(image)


func _physics_process(delta: float) -> void:
	# Let state machine update velocity first
	pass


func clamp_velocity() -> void:
	# Clamp fall speed (called after state physics_update)
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed


func get_current_state() -> String:
	return state_machine.get_current_state_name() if state_machine else ""


func reset_jumps() -> void:
	jumps_remaining = max_jumps


func can_jump() -> bool:
	return jumps_remaining > 0


func consume_jump() -> void:
	if jumps_remaining > 0:
		jumps_remaining -= 1


func is_touching_wall_only() -> bool:
	# Returns true if touching a wall but not on the floor
	return is_on_wall() and not is_on_floor()


func can_wall_jump() -> bool:
	return wall_jump_enabled and is_touching_wall_only()


func perform_wall_jump() -> void:
	# Get the wall normal (points away from wall)
	var wall_normal: Vector2 = get_wall_normal()

	# Apply velocity away from wall and upward
	velocity.x = wall_normal.x * wall_jump_horizontal_boost
	velocity.y = -wall_jump_vertical_boost

	# Wall jump counts as using one jump, leaving one more available
	jumps_remaining = max_jumps - 1
