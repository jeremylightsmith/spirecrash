class_name Arrow
extends RigidBody2D

## Arrow projectile
##
## Handles arrow physics, collision, and sticking behavior

@export var speed: float = 600.0
@export var damage: int = 1

var shooter_id: int = -1
var stuck: bool = false
var velocity_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	# Set collision layers - arrows collide with players and walls
	collision_layer = 8  # Arrow layer
	collision_mask = 7   # Collide with players (1,2) and walls (4)

	# Connect to body entered signal
	body_entered.connect(_on_body_entered)

	# Set gravity scale to 0 initially (arrows fly straight)
	gravity_scale = 0.0


func launch(direction: Vector2, shooter: int) -> void:
	velocity_direction = direction.normalized()
	shooter_id = shooter

	# Set initial velocity
	linear_velocity = velocity_direction * speed

	# Rotate arrow to face direction of travel
	rotation = velocity_direction.angle()

	# Emit signal
	EventBus.arrow_fired.emit(self, shooter_id)


func _physics_process(delta: float) -> void:
	if stuck:
		return

	# Update rotation to match velocity direction
	if linear_velocity.length() > 0:
		rotation = linear_velocity.angle()


func _on_body_entered(body: Node) -> void:
	if stuck:
		return

	# Check if hit a player
	if body is Player:
		var player: Player = body as Player

		# Don't hit yourself
		if player.player_id == shooter_id:
			return

		# Kill the player
		EventBus.player_died.emit(player, player.player_id, shooter_id)

		# Remove arrow
		queue_free()
		return

	# Check if hit a wall or platform (StaticBody2D)
	if body is StaticBody2D:
		stick_to_surface()


func stick_to_surface() -> void:
	stuck = true

	# Stop all motion
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0

	# Make kinematic so it doesn't fall
	freeze = true

	# Optional: queue free after a delay
	await get_tree().create_timer(5.0).timeout
	queue_free()
