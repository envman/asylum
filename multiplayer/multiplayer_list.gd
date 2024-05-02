extends Node3D

@export var child_scene: Resource
#@export_file("*.tscn") var child_scene_path: String
#var child_scene = preload(child_scene_path)

@onready var multiplayer_spawner = $MultiplayerSpawner
@onready var list = $List

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer_spawner.add_spawnable_scene(child_scene.resource_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add(params):
	var child = child_scene.instantiate()
	
	for param in params:
		if param in child:
			child[param] = params[param]
	
	list.add_child(child, true)
	
func get_items():
	return list.get_children()
