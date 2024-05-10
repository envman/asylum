extends Control

@onready var effect_list = $EffectList
@onready var object_inspector = $ObjectInspector

var effects
var character

var spawning

func _ready():
	effects = Load.effects()
	
	for effect in effects:
		var button = Button.new()
		button.text = effect.name
		button.pressed.connect(func():
			spawning = effect
			object_inspector.set_object(spawning)
		)
		effect_list.add_child(button)

func _process(_delta):
	if Input.is_action_just_pressed("leave"):
		queue_free()


func _on_apply_pressed():
	var spawner = character.get_node(^"CharacterModule").get_node(^"Spawner")
	spawner.add(spawning)
