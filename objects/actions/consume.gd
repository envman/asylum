extends Action

@export var uses: int = 0

var hotbar = true

func consume(player):
	if not multiplayer.is_server():
		return
	
	for effect in get_children():
		if effect is Effect:
			var character = player.get_character()
			var spawner = character.get_node(^"CharacterModule/Effects")
			spawner.add_copy(effect)
	
	uses -= 1
	if uses == 0:
		var object = get_parent().get_parent()
		object.get_parent().remove_child(object)
		object.queue_free()
