extends Action

var hotbar = true

func consume(player):
	if not multiplayer.is_server():
		return
	
	for effect in get_children():
		if effect is Effect:
			var character = player.get_character()
			var spawner = character.get_node(^"CharacterModule/Spawner")
			spawner.add(effect)
