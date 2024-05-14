extends Control

@onready var item_list = $ItemList
@onready var action_list = $ActionList

@onready var add_item = $AddItem

var spawn_object_ui_scene = preload("res://teller/spawn_object_ui.tscn")

var inventory: Inventory

signal done

func _ready():
	var player = MultiplayerController.get_local_player()
	add_item.visible = player.teller
	
	for item in inventory.get_children():
		if GameObject.is_game_object(item):
			var object: GameObject = GameObject.object(item)
			
			if not object.inventory:
				continue
			
			var button = Button.new()
			button.text = object.object_name
			button.pressed.connect(func(): select_item(item))
			
			item_list.add_child(button)

func select_item(item):	
	clear_actions()
	
	var obj := GameObject.object(item)
	for action in obj.get_children():
		if action is Action:
			var button = Button.new()
			button.text = action.action_name
			button.pressed.connect(func():
				action.act.rpc_id(1)
				done.emit()
			)
			action_list.add_child(button)

func clear_actions():
	for child in action_list.get_children():
		action_list.remove_child(child)

func _on_add_item_pressed():
	var spawn_object_ui = spawn_object_ui_scene.instantiate()
	spawn_object_ui.object_selected.connect(func(x):
		inventory.pickup(x)
		remove_child(spawn_object_ui)
	)
	add_child(spawn_object_ui)
