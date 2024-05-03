extends Node3D
class_name Spawner

@export var effects: bool = false

@onready var spawner = $MultiplayerSpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	spawner.spawn_path = get_path()
	
	setup_objects("res://objects/effects", Effect.is_effect)

func add(obj):
	var copy = load(obj.scene_file_path).instantiate()
	add_child(copy)

#func spawn(res_path):
	#var owner_id = get_multiplayer_authority()
	#spawn_local.rpc_id(owner_id, res_path)
#
#@rpc("any_peer", "call_local", "reliable")
#func spawn_local(res_path):
	#var obj = load(res_path).instantiate()
	#get_parent().get_parent().add_child(obj)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func setup_objects(folder: String, is_valid: Callable):
	var dir := DirAccess.open(folder)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var path = folder + "/" + file_name
			var obj_scene: PackedScene = load(path)
			var obj = obj_scene.instantiate()
			
			if is_valid.call(obj):
				print("add object", path)
				spawner.add_spawnable_scene(path)

		file_name = dir.get_next()
