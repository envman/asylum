extends Action

var hotbar = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func consume(player):
	if not multiplayer.is_server():
		return
	
	for effect in get_children():
		if effect is Effect:
			var character = player.get_character()
			var spawner = character.get_node(^"CharacterModule/Spawner")
			spawner.add(effect)
