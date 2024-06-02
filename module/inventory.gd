extends Spawnr
class_name Inventory

var module = true

#signal inventory_updated

var inventory_ui_scene = preload("res://module/inventory_ui.tscn")

func has_named_item(item_name: String):
	for child in get_children():
		if child is MultiplayerSpawner:
			continue
		
		if GameObject.is_game_object(child):
			var obj = GameObject.object(child)
			if obj.object_name == item_name:
				return true
	
	return false

func view():
	var inventory_ui = inventory_ui_scene.instantiate()
	inventory_ui.inventory = self
	return inventory_ui
