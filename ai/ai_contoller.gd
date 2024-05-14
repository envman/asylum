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
	
	character_module.state_factory.add_state("guard", GuardState)
	character_module.state_factory.add_state("move_to", MoveToState)
	character_module.state_factory.add_state("attack_character", AttackCharacterState)
	character_module.state_factory.add_state("chase", ChaseState)
	
	character_module.state_context["nav_agent"] = nav_agent
	character_module.state_context["attack"] = _find_attack()
	character_module.start_state = "guard"

func _find_attack():
	var inventory = character_module.get_node(^"Inventory")
	for obj in inventory.get_children():
		if obj.has_node(^"Object"):
			var game_object = obj.get_node(^"Object")
			for action in game_object.get_children():
				if action is Attack:
					return action
