extends Node3D

signal finished

var children_complete = 0

func _ready():
	for child in get_children():
		if "finished" in child:
			child.finished.connect(_child_completed)

func execute():
	for child in get_children():
		child.execute()
		
		if not "finished" in child:
			_child_completed()

func _child_completed():
	children_complete += 1
	
	if children_complete == get_child_count():
		finished.emit()
