extends Effect
class_name ReadingEffect

@export var text: String = "Reading Effect"

var reading_ui_scene = preload("res://objects/effects/reading_ui.tscn")
var ui

func client_start():
	if not local:
		return
	
	ui = reading_ui_scene.instantiate()
	add_child(ui)

func client_process(_delta):
	if not local:
		return
	
	if ui.text != text:
		ui.text = text
	
	if Input.is_action_just_pressed("leave"):
		queue_free()

func copy_to(obj):
	obj.text = text
