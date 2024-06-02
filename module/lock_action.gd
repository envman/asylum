extends Action

@onready var characters = $/root/Main/World/Characters

var is_locked: bool

func _ready():
	get_parent().state_changed.connect(_state_changed)

func _has_key(character):
	var character_module = character.get_node(^"CharacterModule")

	var inventories = character_module.get_children().filter(func(x): return x is Inventory)
	if inventories.size() < 1:
		return false
		
	var inventory = inventories[0]
	for child in inventory.get_children():
		if child is Key and child.code == get_parent().door_code:
			return true
	
	return false

func _state_changed(locked: bool):
	is_locked = locked
	update_name()

func update_name():	
	if is_locked:
		action_name = "Unlock"
	else:
		action_name = "Lock"

@rpc("any_peer", "call_local", "reliable")
func act():
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	
	if _has_key(player.get_character()):
		object.call(method, player)
