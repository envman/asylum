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
