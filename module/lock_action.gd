extends Action

@onready var characters = $/root/Main/World/Characters

var is_locked: bool

func _ready():
	get_parent().state_changed.connect(_state_changed)

func _has_key(character):
	var person = character.get_node(^"Person")

	var inventories = person.get_children().filter(func(x): return x is Inventory)
	if inventories.size() < 1:
		return false
		
	var inventory = inventories[0]
	return inventory.has_named_item("Key")

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
