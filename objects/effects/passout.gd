extends Effect

@export var duration: float = 60

var black_out_scene = preload("res://objects/effects/black_out.tscn")
var black_out

func client_start(local):
	if not local:
		return
	
	black_out = black_out_scene.instantiate()
	add_child(black_out)

	character_module.change_state("lie")


func client_process(local, delta):
	if not local:
		return
	
	duration -= delta

	if duration < 0:
		character_module.change_state("idle")
		queue_free()
