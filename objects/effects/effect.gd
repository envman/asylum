extends Node
class_name Effect

static func is_effect(obj: Node3D):
	for child in obj.get_children():
		if child is Effect:
			return true
			
	return false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
