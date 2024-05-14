extends Action

@export var toggle_name: String
@export var alternate_name: String
@export var property_name: String


@rpc("any_peer", "call_local", "reliable")
func act():
	if not multiplayer.is_server():
		return
	
	object[property_name] = not object[property_name]

func _process(delta):
	if object[property_name]:
		action_name = alternate_name
	else:
		action_name = toggle_name
