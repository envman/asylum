extends Node
class_name AsylumBase

@rpc("any_peer", "call_local", "reliable")
func request_authority():
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if not caller.teller:
		return
	
	get_parent().set_multiplayer_authority(multiplayer.get_remote_sender_id())

@rpc("any_peer", "call_local", "reliable")
func release_authority():
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if multiplayer.get_remote_sender_id() != 1 and not caller.teller:
		return
	
	get_parent().set_multiplayer_authority(1)
