extends Node3D
class_name AttackCharacter

@export var parent: Character
@export var target: Character

func execute():
	var character_module = parent.get_node(^"CharacterModule")
	
	character_module.add_state_context.rpc_id(1, "attack_target", target.get_path())
	character_module.change_state.rpc_id(1, "chase")
