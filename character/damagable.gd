extends Module
class_name Damagable

@onready var health_bar = $SubViewport/ProgressBar

var pass_out_effect_scene = preload("res://objects/effects/passout.tscn")

@export var health := 100:
	set(val):
		health = val
		health_bar.value = val

signal damage_taken

func hit(amount: int, character):
	health = clamp(health - amount, 0, 100)
	damage_taken.emit(amount, character)
	
	if health == 0:
		var pass_out_effect = pass_out_effect_scene.instantiate()
		get_parent().get_node(^"Effects").add_child(pass_out_effect)

func heal(amount: int, character):
	health = clamp(health + amount, 0, 100)
