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
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	
	object.call(method, player)
