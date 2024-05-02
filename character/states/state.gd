extends Node
class_name State

var animation
var player
var last_state
var player_module

func setup(setup_animation, setup_player, setup_player_module, setup_last_state):
	animation = setup_animation
	last_state = setup_last_state
	player = setup_player
	player_module = setup_player_module

func animation_finished(_animation_name):
	pass
