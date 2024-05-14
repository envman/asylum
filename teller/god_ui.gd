extends Control

@export var test: bool = false

@onready var parent = $".."
@onready var camera = $".."
@onready var players: PlayerManager = $/root/Main/Players
@onready var world: World = $/root/Main/World
@onready var object_inspector: Inspector = $RightHandPanel/Inspectors/ObjectInspector
@onready var inspector_label = $RightHandPanel/InspectorLabel

@onready var chat_manager: ChatManager = $/root/Main/World/Chats

@onready var heros = $Heros
@onready var chats = $Chats
@onready var control = $Buttons/Control
@onready var add_effect = $Buttons/AddEffect
@onready var inspectors = $RightHandPanel/Inspectors
@onready var inventory_button = $Buttons/Inventory
@onready var teleport_button = $Buttons/Teleport
@onready var remove_button = $Buttons/Remove


signal mouse_clicked

var chat_ui_scene = preload("res://ui/chat_ui.tscn")
var spawn_object_ui_scene: PackedScene = preload("res://teller/spawn_object_ui.tscn")
var add_effect_ui_scene = preload("res://teller/add_effect_ui.tscn")
#var inventory_ui_scene = preload("res://module/inventory_ui.tscn")
var selected_ring_scene = preload("res://character/selected_ring.tscn")

enum Mode {
	Select,
	SpawnCharacter,
	SpawnNpc,
	Editing,
	Chatting,
	SpawnObject,
	Controlling,
	Teleport
}

var layers_masks = [
	0b00000000_00000000_00000011_11111111,
	0b00000000_00000000_00000111_11111111,
	0b00000000_00000000_00001111_11111111,
	0b00000000_00000000_00011111_11111111,
	0b00000000_00000000_00111111_11111111,
	0b00000000_00000000_01111111_11111111,
	0b00000000_00000000_11111111_11111111,
	0b00000000_00000001_11111111_11111111,
	0b00000000_00000011_11111111_11111111,
	0b00000000_00000111_11111111_11111111,
]

var mode: Mode = Mode.Select
var last_mode: Mode
var selected:
	set(val):
		if selected != val:
			if selected != null:
				_remove_selected_circle(selected)
				inspector_label.text = ""
			
			if val != null:
				_add_selected_circle(val)
				if GameObject.is_game_object(val):
					inspector_label.text = GameObject.object(val).object_name
					
				if val is Character:
					inspector_label.text = val.character_name
				
			selected = val

var selected_modules = []
var spawn_object_ui
var add_effect_ui
var inventory_ui
var mouse_over_ui = false

func _ready():
	heros.get_items = players.get_heros
	heros.render_label("player_name")
	
	chats.get_items = chat_manager.get_chats
	chats.render_item = func(x):
		var button = Button.new()
		button.text = MultiplayerController.get_player_name(x.player_id)
		button.pressed.connect(func(): chat_selected(x))
		return button

func _process(_delta):
	remove_button.visible = selected != null
	control.visible = selected != null and selected is Character
	add_effect.visible = selected != null and selected is Character
	inventory_button.visible = selected != null and selected is Character
	teleport_button.visible = selected != null and (selected is Character or GameObject.is_game_object(selected))
	
	if Input.is_action_just_pressed("leave"):
		if mode == Mode.Controlling:
			visible = true
			selected.get_node(^"CharacterModule").release_player(MultiplayerController.get_local_player().id)
			get_parent().make_current()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_parent().global_position = selected.global_position
			get_parent().global_position.y += 20
			get_parent().enable_levels()
		
		selected = null
		_clear_inspectors()
		object_inspector.set_object(null)
		mode = Mode.Select
		if inventory_ui != null:
			remove_child(inventory_ui)
		
	if mode != last_mode:
		if mode != Mode.Editing:
			_clear_inspectors()
		
		if mode != Mode.SpawnObject:
			_remove_spawn_object_ui()
		
		last_mode = mode

func chat_selected(chat):
	mode = Mode.Chatting
	var chat_ui = chat_ui_scene.instantiate()
	chat_ui.chat = chat
	camera.freeze = true
	add_child(chat_ui)

func _on_npc_pressed():
	mode = Mode.SpawnNpc

func _clear_inspectors():
	for child in inspectors.get_children().filter(func(x): return x != object_inspector):
		inspectors.remove_child(child)

func _add_inspector(obj):
	var ins = Inspector.new()
	ins.set_object(obj)
	ins.set_search_enabled(false)
	ins.custom_minimum_size.y = 100
	inspectors.add_child(ins)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos = mouse_position()
			if mouse_pos != null:
				mouse_clicked.emit(mouse_pos)
			
			if mode == Mode.Teleport:
				selected.global_position = mouse_pos
			
			if mode == Mode.SpawnCharacter:
				var pos = mouse_position()
				if pos != null:
					world.spawn_character.rpc_id(1, pos)
			if mode == Mode.Select:
				
				if mouse_over_ui:
					return

				var obj = get_clicked_object()
				
				if obj != null:
					if obj is Character or GameObject.is_game_object(obj):
					
						select(obj)
						
						_clear_inspectors()
						_add_inspector(obj)
						
						for child in obj.get_children():
							if child is Module:
								_add_inspector(child)
			
			if mode == Mode.SpawnObject:
				return
			
			mode = Mode.Select

func select(object):
	for teller_module in selected_modules:
		remove_child(teller_module)
		
	selected_modules.clear()
		
	print("select: ", object.name)
	selected = object
	
	if not selected.has_node(^"CharacterModule"):
		return
		
	var character_module = selected.get_node(^"CharacterModule")
	for child in character_module.get_children():
		if "teller_modules" in child:
			for teller_module in child.teller_modules:
				var mod = teller_module.instantiate()
				selected_modules.append(mod)
				mod.character = selected
				mod.character_module = character_module
				mod.camera = camera
				add_child(mod)
	
	#for child in object.get_children():
		#if not child is Module:
			#continue
#
		#if "teller_modules" in child:
			#for teller_module in child.teller_modules:
				#var mod = teller_module.instantiate()
				#mod.module = child
				#mod.camera = camera
				#mod.parent = parent
				#add_child(mod)
				

func get_mouse_raycast():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = parent.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = layers_masks[camera.ui_level]
	ray_query.collide_with_areas = true
	
	return space.intersect_ray(ray_query)

func get_clicked_object():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = parent.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = layers_masks[camera.ui_level]
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	
	if raycast_result.has("collider"):
		return raycast_result.collider
	
	return null

func mouse_position():
	#var pos = get_global_mouse_position()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 100
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var space = parent.get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collision_mask = layers_masks[camera.ui_level]
	ray_query.collide_with_areas = true
	var raycast_result = space.intersect_ray(ray_query)
	
	if raycast_result != null and raycast_result.has("position"):
		return raycast_result.position

func _on_character_pressed():
	mode = Mode.SpawnCharacter

func _on_control_pressed():
	if selected != null and selected is Character:
		get_parent().disable_levels()
		
		selected.get_node(^"CharacterModule").accept_player(MultiplayerController.get_local_player().id)
		visible = false
		mode = Mode.Controlling

func _on_test_pressed():
	print("saving")
	#for c in $/root/Main/World/Characters.get_children():
		#print(c.name)
		#if c.owner != null:
			#print(c.owner.name)
	
	var scene = PackedScene.new()
	scene.pack(world)
	ResourceSaver.save(scene, "res://test/test.tscn")
	print("saved")

func _remove_spawn_object_ui():
	if spawn_object_ui != null:
		print(spawn_object_ui.name)
		mouse_clicked.disconnect(spawn_object_ui.mouse_clicked)
		remove_child(spawn_object_ui)
		spawn_object_ui = null

func _on_spawn_object_pressed():
	mode = Mode.SpawnObject
	spawn_object_ui = spawn_object_ui_scene.instantiate()
	mouse_clicked.connect(spawn_object_ui.mouse_clicked)
	
	add_child(spawn_object_ui)

func _on_add_effect_pressed():
	add_effect_ui = add_effect_ui_scene.instantiate()
	add_effect_ui.character = selected
	add_child(add_effect_ui)


func _on_inventory_pressed():
	var inventory = selected.get_node(^"CharacterModule/Inventory")
	if inventory != null:
		inventory_ui = inventory.view()
		add_child(inventory_ui)


func _on_remove_pressed():
	if selected:
		selected.get_parent().remove_child(selected)
		#if "remove" in selected.get_parent():
			#selected.get_parent().remove(selected)
		selected = null

func _add_selected_circle(obj):
	var selected_ring = selected_ring_scene.instantiate()
	obj.add_child(selected_ring)
	
func _remove_selected_circle(obj):
	for child in obj.get_children():
		if child is SelectedRing:
			obj.remove_child(child)
			


func _on_ui_mouse_entered():
	mouse_over_ui = true


func _on_ui_mouse_exited():
	mouse_over_ui = false


func _on_teleport_pressed():
	mode = Mode.Teleport
