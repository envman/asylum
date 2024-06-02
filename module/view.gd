extends Action

@export var scene: PackedScene

func act_local():
	var player = MultiplayerController.get_local_player()
	var character = get_node(player.character)
	var character_module = character.get_node(^"CharacterModule")
	var inventory = character.get_node(^"CharacterModule/Inventory")
	
	var inst = scene.instantiate()
	inst.set_objects(inventory, get_parent())
	inst.left_name = character.name
	inst.right_name = GameObject.object(get_parent().get_parent()).object_name
	character_module.add_child_ui(inst)

#@rpc("any_peer", "call_local", "reliable")
#func act():
	#Log.log("view.act()")
	#if not multiplayer.is_server():
		#return
	
	#var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	
	#object.call(method, player)
