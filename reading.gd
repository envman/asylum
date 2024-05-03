extends Effect

var reading_ui_scene = preload("res://objects/effects/reading_ui.tscn")
var ui

func client_start(local):
	if not local:
		return
	
	ui = reading_ui_scene.instantiate()
	add_child(ui)

func client_process(local, delta):
	if not local:
		return
	
	if Input.is_action_just_pressed("leave"):
		queue_free()
