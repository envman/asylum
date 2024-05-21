extends Node3D

var character: Character
var character_module: CharacterModule
var camera

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			var raycast_result = get_parent().get_mouse_raycast()
			
			if raycast_result.collider != null and raycast_result.collider is Character and raycast_result.collider != character:
				var target = raycast_result.collider as Character
				
				character_module.add_state_context.rpc_id(1, "attack_target", target.get_path())
				#character_module.state_context["attack_target"] = raycast_result.collider
				character_module.change_state.rpc_id(1, "chase")
				return

			var pos = raycast_result.position
			if pos != null:
				character_module.remove_state_context.rpc_id(1, "attack_target")
				character_module.add_state_context.rpc_id(1, "target_position", pos)
				#if character_module.state_context.has("attack_target"):
					#character_module.state_context.erase("attack_target")
				#character_module.state_context["nav_agent"].target_position = pos
				character_module.change_state.rpc_id(1, "move_to")
