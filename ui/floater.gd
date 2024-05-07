extends Label3D

var duration: float = 1.0
var color := Color.FIREBRICK

func _ready():
	modulate = color

func _process(delta):
	duration -= delta
	global_position.y += delta * 3
	
	if duration < 0:
		queue_free()
