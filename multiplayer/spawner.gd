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
		
	add_child(copy, true)
	
	if "copy_to" in obj:
		obj.copy_to(copy)

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
				spawner.add_spawnable_scene(path)

		file_name = dir.get_next()
