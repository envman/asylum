extends Node3D
class_name AIController

var teller_modules = [
	preload("res://ai/ai_controller_teller_module.tscn")
]

@onready var nav_agent = $NavigationAgent3D

var character: Character
var character_module = CharacterModule

func _ready():
	character = get_parent().get_parent()
	character_module = character.get_node(^"CharacterModule")
	
	character_module.state_factory.add_state("move_to", MoveToState)
	character_module.state_factory.add_state("attack_character", AttackCharacterState)
	character_module.state_factory.add_state("chase", ChaseState)
	
	character_module.state_context["nav_agent"] = nav_agent

func _process(_delta):
	pass

func _physics_process(_delta):
	if character == null:
		return
