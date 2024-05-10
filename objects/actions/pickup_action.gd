extends Action

@onready var characters = $/root/Main/World/Characters
@onready var objects = $/root/Main/World/NavigationRegion/Objects

func _ready():
	if in_inventory():
		action_name = "Drop"

@rpc("any_peer", "call_local", "reliable")
func act():
	if not multiplayer.is_server():
		return
	
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	var character = player.get_character()
	var character_module = character.get_node(^"CharacterModule")
	
	var modules = character_module.get_children().filter(func(x): return x is Inventory)
	if modules.size() == 1:
		var inventory = modules[0]
		var obj = get_parent().get_parent()
		
		if in_inventory():
			inventory.remove(obj)
			objects.add(obj, character.global_position)
		else:
			objects.remove(obj)
			#inventory.pickup(obj)
