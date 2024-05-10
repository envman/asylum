extends Module

@onready var world = $/root/Main/World

@export var open: bool = false:
	set(val):
		open = val
		state_changed.emit(open)

var last_state
var closed_rotation
var open_rotation
var duration = 2.0
var target_rotation

var progress = 0.0
var start_rotation
var parent

signal state_changed

func _ready():
	get_parent().set_collision_layer_value(2, true)
	
	parent = get_parent()
	closed_rotation = parent.rotation_degrees.y
	open_rotation = closed_rotation + 90
	last_state = open
	
	if open:
		target_rotation = open_rotation
	else:
		target_rotation = closed_rotation
		
	parent.rotation_degrees.y = target_rotation

func _process(delta):
	if parent.rotation_degrees.y != target_rotation:
		parent.rotation_degrees.y = lerp(start_rotation, target_rotation, progress / duration)
		progress += delta
		
		if abs(parent.rotation_degrees.y - target_rotation) < 1:
			parent.rotation_degrees.y = target_rotation
			finished()
	else:
		if open != last_state:
			start_rotation = parent.rotation_degrees.y
			progress = 0
			
			if open:
				target_rotation = open_rotation
			else:
				target_rotation = closed_rotation
				
			last_state = open

func finished():
	world.bake_navigation_mesh()

func toggle_open(_player):
	open = !open
