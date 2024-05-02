extends Action

@onready var characters = $/root/Main/World/Characters

var is_locked: bool

func _ready():
	get_parent().state_changed.connect(_state_changed)

func _has_key():
	var player = MultiplayerController.get_player(get_multiplayer_authority())
	var character = player.get_character()
	
	if character == null:
		return false
	#var character = characters.get_children().filter(func(x): return x.get_multiplayer_authority() == player.id)[0]

	var inventories = character.get_children().filter(func(x): return x is Inventory)
	#print("inventories: ", inventories.size())
	if inventories.size() < 1:
		return false
		
	var inventory = inventories[0]
	
	return inventory.has_named_item("Key")

func _state_changed(locked: bool):
	is_locked = locked
	update_name()

func update_name():
	var key = _has_key()
	
	if _has_key():
		if is_locked:
			action_name = "Unlock"
		else:
			action_name = "Lock"
	else:
		if is_locked:
			action_name = "Unlock (KEY REQUIRED)"
		else:
			action_name = "Lock (KEY REQUIRED)"

func _process(delta):
	update_name()

@rpc("any_peer", "call_local", "reliable")
func act():
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	#var character = characters.get_children().filter(func(x): return x.get_multiplayer_authority() == player.id)[0]
	
	if _has_key():
		object.call(method, player)
