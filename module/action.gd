extends Node
class_name Action

@export var action_name: String:
	set(val):
		action_name = val
		name_updated.emit(val)
		
@export var object: Node
@export var method: String

@export var cooldown: float = 1.0

signal name_updated
signal available_updated

var available = true:
	set(val):
		if available != val:
			available_updated.emit(val)	

		available = val
		

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
