extends Node
class_name Action

@export var action_name: String:
	set(val):
		action_name = val
		name_updated.emit(val)
		
@export var object: Node
@export var method: String

signal name_updated

@rpc("any_peer", "call_local", "reliable")
func act():
	if not multiplayer.is_server():
		return
	
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	
	object.call(method, player)

func in_inventory() -> bool:
	var game_object = get_parent()
	if game_object == null:
		return false
	
	var object = game_object.get_parent()
	if object == null:
		return false
	
	var inventory = object.get_parent()
	if inventory == null:
		return false
	
	return inventory is Inventory
	
	
	#var person = character.get_node(^"Person")
#
	#var inventories = person.get_children().filter(func(x): return x is Inventory)
	#if inventories.size() < 1:
		#return false
		#
	#var inventory = inventories[0]
	#return inventory.has_named_item("Key")
