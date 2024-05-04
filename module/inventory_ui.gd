extends Control

@onready var item_list = $ItemList
@onready var action_list = $ActionList

var inventory: Inventory

signal done

func _ready():
	for item in inventory.get_children():
		if GameObject.is_game_object(item):
			var object: GameObject = GameObject.object(item)
			
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

func _process(delta):
	pass
