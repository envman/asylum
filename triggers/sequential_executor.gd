extends Node3D

signal finished

var current_index = 0

func _ready():
	for child in get_children():
		if "finished" in child:
			child.finished.connect(_child_completed)

@rpc("any_peer", "call_local", "reliable")
func execute():
	if not multiplayer.is_server():
		return
	
	current_index = 0
	run_current()

	#children_complete = 0
	
	#for child in get_children():
		#child.execute()

func run_current():
	var child = get_child(current_index)
	child.execute()
	
	if not "finished" in child:
		_child_completed()

func _child_completed():
	current_index += 1
	
	if current_index < get_child_count():
		run_current()
	else:
		finished.emit()
	#children_complete += 1
	
	#if children_complete == get_child_count():
		#finished.emit()
