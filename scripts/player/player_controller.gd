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

# State machine reference
@onready var state_machine: PlayerStateMachine = get_node_or_null("StateMachine")
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")


func _ready() -> void:
	# Set player color based on ID
	if sprite:
		sprite.modulate = GameManager.get_player_color(player_id)

	# Emit spawn signal
	EventBus.player_spawned.emit(self, player_id)


func _physics_process(_delta: float) -> void:
	# Clamp fall speed
	if velocity.y > max_fall_speed:
		velocity.y = max_fall_speed


func get_current_state() -> String:
	return state_machine.get_current_state_name() if state_machine else ""
