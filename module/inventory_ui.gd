extends Control

@onready var item_list = $ItemList
@onready var action_list = $ActionList
@onready var add_item = $AddItem
@onready var label = $Label

var spawn_object_ui_scene = preload("res://teller/spawn_object_ui.tscn")
var other_container
var title = "Inventory"

var inventory: Inventory:
	set(val):
		inventory = val
		
		if inventory != null:
			inventory.children_updated.connect(inventory_updated)
		
		if item_list != null and inventory != null:
			load_items()

signal done

func inventory_updated():
	for item in item_list.get_children():
		item_list.remove_child(item)
		
	clear_actions()
	load_items()

func _ready():
	var player = MultiplayerController.get_local_player()
	add_item.visible = player.teller
	
	if inventory != null:
		load_items()

func load_items():
	for item in inventory.get_children():
		if GameObject.is_game_object(item):
			var object: GameObject = GameObject.object(item)
			
			if not object.inventory:
				continue
			
			var button = Button.new()
			button.text = object.object_name
			button.pressed.connect(func(): select_item(item))
			
			item_list.add_child(button)

# TODO: add transfer action
func select_item(item):
	if other_container != null:
		var swap = Swap.new()
		swap.from = item
		swap.to = other_container
		swap.run()
		
		return
	
	clear_actions()
	
	var obj := GameObject.object(item)
	
	#if other_container != null:
#
		#print("other_container", other_container.get_path())
		#
		#var button = Button.new()
		#button.text = "Transfer"
		#button.pressed.connect(func():
			#print("SWAP")
			#
		#)
		#action_list.add_child(button)
	
	for action in obj.get_children():
		if action is Action:
			var button = Button.new()
			button.text = action.action_name
			button.pressed.connect(func():
				action.run()
				#action.act.rpc_id(1)
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

func _process(delta):
	label.text = title
