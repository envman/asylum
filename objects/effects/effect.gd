extends Node
class_name Effect

static func is_effect(obj: Node):
	if obj is Effect:
		return true
			
	return false

var active := false
var local := false

var character: Character
var character_module: CharacterModule

func _ready():
	if get_parent().get_parent() is CharacterModule:
		active = true
		character_module = get_parent().get_parent()
		
		if character_module.player:
			local = true
			
		character = character_module.get_parent()
		
		client_start()

		if multiplayer.is_server():
			server_start()

func client_start():
	pass

func server_start():
	pass

func _process(delta):
	if active:
		client_process(delta)
	
	if multiplayer.is_server():
		server_process(delta)

func client_process(_delta):
	pass

func server_process(_delta):
	pass
