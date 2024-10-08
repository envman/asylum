extends Control

@onready var label = $Label
@onready var actions_list = $Actions

var object_name = ""
var actions = []

var index = 0:
	set(val):
		index = val
		_update_colors()

func _update_colors():
	for action_label: Label in actions_list.get_children():
		action_label.add_theme_color_override("font_color", Color.DARK_GRAY)
	
	if actions_list.get_child_count() <= index:
		return
		
	var label: Label = actions_list.get_child(index)
	if label != null:
		label.add_theme_color_override("font_color", Color.WHITE)

func _ready():
	_update_colors()
	
	label.text = object_name

func _enter_tree():
	UI.focus = true

func _exit_tree():
	UI.focus = false

func add_action(action: Action):
	actions.append(action)
	var label = Label.new()
	label.text = action.action_name
	action.name_updated.connect(func(x): 
		label.text = x)
	actions_list.add_child(label)
	
	_update_colors()

func _process(_delta):
	if Input.is_action_just_pressed("select"):
		if actions.size() == 0:
			return
		
		actions[index].run()
		#actions[index].act.rpc_id(1)
		
	if Input.is_action_just_pressed("action_next"):
		index = clamp(index + 1, 0, actions.size() - 1)
		
	if Input.is_action_just_pressed("action_last"):
		index = clamp(index - 1, 0, actions.size() - 1)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			index = clamp(index + 1, 0, actions.size() - 1)
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			index = clamp(index - 1, 0, actions.size() - 1)

	#if event is InputEventPanGesture and gesture_ignore_time < 0:
		#if event.delta.y > 1:
			#index = clamp(index + 1, 0, actions.size() - 1)
			#
		#if event.delta.y < 1:
			#index = clamp(index - 1, 0, actions.size() - 1)
