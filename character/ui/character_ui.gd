extends Control

var cooldown_button_scene = preload("res://ui/cooldown_button.tscn")

@onready var camera = $SubViewportContainer/SubViewport/Camera3D

var parent_camera: Camera3D
var camera_controller
var character_module: CharacterModule
var inventory: Spawnr

@onready var hotbar = $Actions

var actions = []

func _ready():
	character_module = get_parent().get_parent().get_parent().get_parent()
	parent_camera = get_parent().get_parent().get_parent().get_parent().get_node("FaceCamera")
	inventory = character_module.get_node("Inventory")
	
	_load_actions()
	
	# TODO: fix this!
	inventory.children_updated.connect(_load_actions)
	#inventory.inventory_updated.connect(_load_actions)

func _process(_delta):
	camera.transform = parent_camera.get_global_transform()

	if Input.is_action_just_pressed("hotbar_1"):
		_fire_action(0)
	if Input.is_action_just_pressed("hotbar_2"):
		_fire_action(1)
	if Input.is_action_just_pressed("hotbar_3"):
		_fire_action(2)
	if Input.is_action_just_pressed("hotbar_4"):
		_fire_action(3)
	if Input.is_action_just_pressed("hotbar_5"):
		_fire_action(4)
	if Input.is_action_just_pressed("hotbar_6"):
		_fire_action(5)
	if Input.is_action_just_pressed("hotbar_7"):
		_fire_action(6)
	if Input.is_action_just_pressed("hotbar_8"):
		_fire_action(7)
	if Input.is_action_just_pressed("hotbar_9"):
		_fire_action(8)
	if Input.is_action_just_pressed("hotbar_0"):
		_fire_action(9)

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if actions.size() > 0:
				#_fire_action(0)

func _fire_action(index):
	if actions.size() <= 0:
		return
	
	var button = hotbar.get_child(index)
	
	if button.can_fire():
		var action = actions[index]
		if not action.available:
			return
		
		if "state" in action:
			character_module.change_state(action.state)
			
		#action.act.rpc_id(1)
		action.run()
		button.click()

func _load_actions():
	actions.clear()
	
	for child in hotbar.get_children():
		hotbar.remove_child(child)
		
	
	var index = 1
	
	for obj in inventory.get_children():
		if "get_children" not in obj:
			continue
		
		var object = obj.get_node(^"Object")
		if object != null:
			for action in object.get_children():
				if action is Action:
					if "hotbar" in action and action.hotbar:
						var button = cooldown_button_scene.instantiate()
						button.cooldown = action.cooldown
						button.text = str(index) + ": " + action.action_name
						hotbar.add_child(button)
						actions.append(action)
						action.available_updated.connect(func(x): button.available = x)
						
						index += 1
			
