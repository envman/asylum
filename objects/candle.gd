extends Node3D

@onready var model = $Model
@onready var model_lit = $ModelLit

@export var lit: bool = true

func _process(delta):
	model_lit.visible = lit
	model.visible = not lit
