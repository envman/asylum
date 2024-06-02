extends Action
class_name WHam

var hotbar = true

@onready var world = $/root/Main/World

@rpc("any_peer", "call_local", "reliable")
func act():
	if not multiplayer.is_server():
		return
	
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	var character = get_node(player.character)
	var targeter: Targeter = character.get_node(^"CharacterModule/Targeter")
	
	if targeter.target:
		print(targeter.target.name)
		
		if targeter.target is GridMap:
			var grid_map: GridMap = targeter.target
			print("hit_pos", targeter.hit_pos)
			
			var light = OmniLight3D.new()
			
			light.global_position = targeter.hit_pos - (targeter.hit_normal * 2)
			
			light.light_energy = 8
			world.add_child(light)
			
			#var points = [targeter.hit_pos - targeter.hit_normal, targeter.hit_pos - targeter.hit_normal]
			#
			#for point in points:
			## TODO: to local?
				#var map = grid_map.local_to_map(point)
				##var map = grid_map.local_to_map(targeter.hit_pos + targeter.hit_normal)
				#print("map_pos", map)
				#
				#var used = grid_map.get_used_cells()
				#print("used", used)
				#
				#var item = grid_map.get_cell_item(map)
				#print("item", item)
				#
				#var level: Level = grid_map.get_parent()
				#level.remove.rpc(map)
			
			#grid_map.set_cell_item(map, GridMap.INVALID_CELL_ITEM)
		
	#object.call(method, player)
