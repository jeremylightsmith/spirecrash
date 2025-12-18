class_name State
extends Node

## Base class for all player states
##
## Provides a common interface for state behavior in the state machine.
## All state-specific logic should be implemented in subclasses.

var state_machine: Node = null
var player: CharacterBody2D = null


func _ready() -> void:
	if owner:
		await owner.ready
		player = owner as CharacterBody2D
	if player == null and get_parent() and get_parent().get_parent():
		# Handle case where state machine is child of player
		player = get_parent().get_parent() as CharacterBody2D


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass
