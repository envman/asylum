extends Module
class_name Damagable

@onready var health_bar = $HealthBar/SubViewport/ProgressBar

var pass_out_effect_scene = preload("res://objects/effects/passout.tscn")

@export var health := 100:
	set(val):
		health = val
		health_bar.value = val

func hit(amount: int):
	health = clamp(health - amount, 0, 100)
	
	if health == 0:
		var pass_out_effect = pass_out_effect_scene.instantiate()
		get_parent().get_node(^"Spawner").add(pass_out_effect)
