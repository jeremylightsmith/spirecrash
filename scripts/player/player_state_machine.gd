class_name PlayerStateMachine
extends Node

## Manages state transitions for the player
##
## Handles the current state and coordinates transitions between states.
## States must be direct children of this node.

@export var initial_state: State = null

var current_state: State = null
var states: Dictionary = {}


func _ready() -> void:
	if owner:
		await owner.ready

	# Register all child states
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_machine = self

	# Start with initial state (use first state if not specified)
	if initial_state:
		current_state = initial_state
	elif states.has("idle"):
		current_state = states["idle"]
	elif states.size() > 0:
		current_state = states.values()[0]

	if current_state:
		current_state.enter()


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)


func transition_to(target_state_name: String) -> void:
	var target_state_key: String = target_state_name.to_lower()

	if not states.has(target_state_key):
		push_warning("State '%s' does not exist" % target_state_name)
		return

	if current_state == states[target_state_key]:
		return

	if current_state:
		current_state.exit()

	current_state = states[target_state_key]
	current_state.enter()


func get_current_state_name() -> String:
	return current_state.name if current_state else ""
