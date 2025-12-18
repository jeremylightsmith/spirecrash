extends GutTest

## Unit tests for PlayerStateMachine

var state_machine: PlayerStateMachine
var player: CharacterBody2D
var idle_state: State
var move_state: State
var jump_state: State


func before_each() -> void:
	# Create test player
	player = autofree(CharacterBody2D.new())
	player.name = "TestPlayer"
	add_child_autofree(player)

	# Create state machine
	state_machine = autofree(PlayerStateMachine.new())
	state_machine.name = "StateMachine"
	player.add_child(state_machine)

	# Create test states
	idle_state = autofree(State.new())
	idle_state.name = "Idle"
	state_machine.add_child(idle_state)

	move_state = autofree(State.new())
	move_state.name = "Move"
	state_machine.add_child(move_state)

	jump_state = autofree(State.new())
	jump_state.name = "Jump"
	state_machine.add_child(jump_state)

	# Manually call _ready to initialize state machine in tests
	state_machine.initial_state = idle_state
	state_machine._ready()
	await wait_physics_frames(1)


func test_state_machine_registers_child_states() -> void:
	assert_eq(state_machine.states.size(), 3, "Should register 3 states")
	assert_true(state_machine.states.has("idle"), "Should have 'idle' state")
	assert_true(state_machine.states.has("move"), "Should have 'move' state")
	assert_true(state_machine.states.has("jump"), "Should have 'jump' state")


func test_state_machine_starts_with_initial_state() -> void:
	assert_eq(state_machine.current_state, idle_state, "Should start in idle state")
	assert_eq(state_machine.get_current_state_name(), "Idle", "Current state name should be 'Idle'")


func test_state_machine_transitions_to_valid_state() -> void:
	state_machine.transition_to("Move")
	assert_eq(state_machine.current_state, move_state, "Should transition to move state")
	assert_eq(state_machine.get_current_state_name(), "Move", "Current state name should be 'Move'")


func test_state_machine_ignores_invalid_state() -> void:
	state_machine.transition_to("InvalidState")
	assert_eq(state_machine.current_state, idle_state, "Should remain in idle state")


func test_state_machine_ignores_transition_to_same_state() -> void:
	var initial_state: State = state_machine.current_state
	state_machine.transition_to("Idle")
	assert_eq(state_machine.current_state, initial_state, "Should remain in same state")


func test_state_machine_is_case_insensitive() -> void:
	state_machine.transition_to("MOVE")
	assert_eq(state_machine.current_state, move_state, "Should transition with uppercase")

	state_machine.transition_to("jump")
	assert_eq(state_machine.current_state, jump_state, "Should transition with lowercase")
