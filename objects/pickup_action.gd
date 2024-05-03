extends Action

@onready var characters = $/root/Main/World/Characters
@onready var objects = $/root/Main/World/Objects

@rpc("any_peer", "call_local", "reliable")
func act():
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	var character = player.get_character()
	#var character = characters.get_children().filter(func(x): return x.get_multiplayer_authority() == player.id)[0]
	var person = character.get_node(^"Person")
	
	var modules = person.get_children().filter(func(x): return x is Inventory)
	if modules.size() == 1:
		var inventory = modules[0]
		var obj = get_parent().get_parent()
		objects.remove_child(obj)
		
		inventory.pickup(obj)
		
		#inventory.spawn.rpc_id(player.id, "res://objects/key.tscn")
		#inventory.spawn.rpc_id(player.id, obj.scene_file_path)
		#var packed = PackedScene.new()
		#packed.pack(obj)
		#inventory.add_child(scene.instantiate())
