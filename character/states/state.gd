extends Node
class_name State

var animation
var player
var last_state

func setup(setup_animation, setup_player, setup_last_state):
	self.animation = setup_animation
	self.last_state = setup_last_state
	self.player = setup_player

func animation_finished(_animation_name):
	pass
