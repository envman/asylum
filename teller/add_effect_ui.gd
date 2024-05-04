extends Control

@onready var effect_list = $EffectList

var effects
var character

func _ready():
	effects = Load.effects()
	
	for effect in effects:
		var button = Button.new()
		button.text = effect.name
		button.pressed.connect(func():
			var spawner = character.get_node(^"Person").get_node(^"Spawner")
			spawner.add(effect)
		)
		effect_list.add_child(button)

func _process(delta):
	if Input.is_action_just_pressed("leave"):
		queue_free()
