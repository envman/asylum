extends Module
class_name Inventory

@onready var multiplayer_spawner = $MultiplayerSpawner

func _ready():
	multiplayer_spawner.spawn_path = get_path()
	
	GameObject.setup_objects(multiplayer_spawner)

func has_named_item(name: String):
	for child in get_children():
		if child is MultiplayerSpawner:
			continue
		
		var obj = GameObject.object(child)
		if obj.object_name == name:
			return true
	
	return false

@rpc("any_peer", "reliable")
func spawn(path):
	var scene = load(path)
	var obj = scene.instantiate()
	add_child(obj, true)
