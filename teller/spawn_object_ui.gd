extends Control

@onready var objects_list := $ObjectsList
@onready var spawned_objects = $/root/Main/World/NavigationRegion/Objects

var objects := []
var spawning

signal object_selected

func _ready():
	_load_objects()
	
	for object in objects:
		_add_object(object)
		
func _load_objects():
	_find_objects("res://objects")

func _find_objects(search_path):
	var dir := DirAccess.open(search_path)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		var path = search_path + "/" + file_name
		
		if dir.current_is_dir():
			_find_objects(path)
		
		if file_name.ends_with(".tscn"):
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
