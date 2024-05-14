extends Node3D

var character: Character
var character_module: CharacterModule
var camera

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			var raycast_result = get_parent().get_mouse_raycast()
			
			#scharacter_module.state_context["attack"] = _find_attack()
			
			if raycast_result.collider != null and raycast_result.collider is Character and raycast_result.collider != character:
				character_module.state_context["attack_target"] = raycast_result.collider
				character_module.change_state("chase")
				return

			var pos = raycast_result.position
			if pos != null:
				if character_module.state_context.has("attack_target"):
					character_module.state_context.erase("attack_target")
				character_module.state_context["nav_agent"].target_position = pos
				character_module.change_state("move_to")
