extends Control

@onready var objects_list := $ObjectsList
@onready var spawned_objects = $/root/Main/World/Objects

var objects := []
var spawning

signal object_selected

func _ready():
	_load_objects()
	
	for object in objects:
		_add_object(object)
		
func _load_objects():
	var dir := DirAccess.open("res://objects")
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var path = "res://objects/" + file_name
			var obj_scene: PackedScene = load(path)
			var obj = obj_scene.instantiate()
			
			if GameObject.is_game_object(obj):
				objects.append({ "object_name": GameObject.object(obj).object_name, "path": path })

		file_name = dir.get_next()

func _add_object(obj):
	var button := Button.new()
	button.text = obj.object_name
	button.pressed.connect(func():
		var scene = load(obj.path)
		spawning = scene.instantiate()
		object_selected.emit(spawning)
	)
	
	objects_list.add_child(button)

func mouse_clicked(pos):
	if spawning != null:
		spawning.global_position = pos
		spawned_objects.add_child(spawning, true)
		spawning = null
