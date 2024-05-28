extends Node
class_name Load

static func effects():
	var folder = "res://objects/effects"
	var dir := DirAccess.open(folder)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	var res = []
	
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var path = folder + "/" + file_name
			var obj_scene: PackedScene = load(path)
			var obj = obj_scene.instantiate()
			
			if obj is Effect:
				res.append(obj)
		file_name = dir.get_next()
		
	return res

static func find_all_with_filter(search_path, filter, sub_directories = true):
	var folder = "res://" + search_path
	var objects = []
	
	_find(folder, filter, objects, sub_directories)
	
	return objects
	#var dir := DirAccess.open(folder)
	#dir.list_dir_begin()
	#var file_name := dir.get_next()
	#
	#var res = []
	#
	#while file_name != "":
		#if file_name.ends_with(".tscn"):
			#var path = folder + "/" + file_name
			#var obj_scene: PackedScene = load(path)
			#var obj = obj_scene.instantiate()
			#
			#if obj is Effect:
				#res.append(obj)
		#file_name = dir.get_next()
		#
	#return res
	
static func _find(search_path, filter: Callable, objects, sub_directories):
	var dir := DirAccess.open(search_path)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	
	while file_name != "":
		var path = search_path + "/" + file_name
		
		if sub_directories and dir.current_is_dir():
			_find(path, filter, objects, true)
		
		if file_name.ends_with(".tscn"):
			var obj_scene: PackedScene = load(path)
			var obj = obj_scene.instantiate()
			
			if filter.call(obj):
				objects.append(obj)
			#if GameObject.is_game_object(obj):
				#objects.append({ "object_name": GameObject.object(obj).object_name, "path": path })

		file_name = dir.get_next()
