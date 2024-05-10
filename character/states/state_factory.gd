extends Node

class_name StateFactory

var states: Dictionary

func _init():
	states = {
		"idle": IdleState,
		"attack": AttackState,
		"move": MoveState,
		"jump": JumpState,
		"chat": ChatState,
		"lie": LieState,
	}

func add_state(state_name: String, type):
	states[state_name] = type

func get_state(state_name: String):
	if states.has(state_name):
		return states.get(state_name)
	
	print("State not found: " + state_name)
