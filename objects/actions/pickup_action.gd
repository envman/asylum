extends Action

@onready var characters = $/root/Main/World/Characters
@onready var objects = $/root/Main/World/NavigationRegion/Objects

func _ready():
	var parent = get_parent()
	if parent.heavy:
		available = false

@rpc("any_peer", "call_local", "reliable")
func act():
	if not multiplayer.is_server():
		return
	
	var obj = get_parent().get_parent()
	
	if in_inventory():
		var inventory = obj.get_parent()
		var character = inventory.get_parent().get_parent()
		
		objects.move(obj)
		obj.global_position = character.global_position
	else:
		var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
		var character = player.get_character()
		var inventory = character.get_node(^"CharacterModule/Inventory")
		inventory.move(obj)

func _enter_tree():
	if in_inventory():
		action_name = "Drop"
	else:
		action_name = "Pickup"
