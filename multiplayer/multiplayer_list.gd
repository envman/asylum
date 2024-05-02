extends Node3D

@export var child_scene: Resource
#@export_file("*.tscn") var child_scene_path: String
#var child_scene = preload(child_scene_path)

@onready var multiplayer_spawner = $MultiplayerSpawner
@onready var list = $List

func _ready():
	multiplayer_spawner.add_spawnable_scene(child_scene.resource_path)

func add(params):
	var child = child_scene.instantiate()
	
	for param in params:
		if param in child:
			child[param] = params[param]
	
	list.add_child(child, true)
	
func get_items():
	return list.get_children()
