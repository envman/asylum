extends Node
class_name GameObject

static func is_game_object(obj: Node3D):
	for child in obj.get_children():
		if child is GameObject:
			return true
			
	return false

static func object(obj: Node3D):
	for child in obj.get_children():
		if child is GameObject:
			return child
	
	return null

static func setup_objects(multiplayer_spawner: MultiplayerSpawner):
	var dir := DirAccess.open("res://objects")
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var path = "res://objects/" + file_name
			var obj_scene: PackedScene = load(path)
			var obj = obj_scene.instantiate()
			
			if GameObject.is_game_object(obj):
				print("add spawnable", path)
				multiplayer_spawner.add_spawnable_scene(path)

		file_name = dir.get_next()

@export var object_name: String

@onready var sync = $MultiplayerSynchronizer

func _ready():
	sync.root_path = ^"../.."
	#sync.root_path = get_parent().get_path()
	
	var config: SceneReplicationConfig = sync.replication_config
	config.add_property(^".:position")
	
	#print(sync.root_path)
	#print(sync.replication_config.get_properties())
	
	
	
