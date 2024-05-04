extends Node3D

func remove(obj):
	confirm_deleted.rpc(obj.get_path())
	#remove_child(obj)

@rpc("authority", "call_local", "reliable")
func confirm_deleted(path):
	var obj = get_node(path)
	if obj != null:
		remove_child(obj)

func add(obj, pos):
	var mine = load(obj.scene_file_path).instantiate()
	mine.global_position = pos
	add_child(mine, true)
