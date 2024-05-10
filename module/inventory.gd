extends Module
class_name Inventory

@onready var multiplayer_spawner = $MultiplayerSpawner

signal inventory_updated

var inventory_ui_scene = preload("res://module/inventory_ui.tscn")

func _ready():
	multiplayer_spawner.spawn_path = get_path()
	
	GameObject.setup_objects(multiplayer_spawner)
	
	multiplayer_spawner.spawned.connect(func(_x): inventory_updated.emit())
	multiplayer_spawner.despawned.connect(func(_x): inventory_updated.emit())

func has_named_item(item_name: String):
	for child in get_children():
		if child is MultiplayerSpawner:
			continue
		
		var obj = GameObject.object(child)
		if obj.object_name == item_name:
			return true
	
	return false

func pickup(obj):
	var mine = load(obj.scene_file_path).instantiate()
	add_child(mine, true)
	inventory_updated.emit()

func remove(obj):
	confirm_deleted.rpc(obj.get_path())
	inventory_updated.emit()
	#remove_child(obj)

@rpc("authority", "call_local", "reliable")
func confirm_deleted(path):
	var obj = get_node(path)
	if obj != null:
		inventory_updated.emit()
		remove_child(obj)

#@rpc("any_peer", "reliable")
#func spawn(path):
	#var scene = load(path)
	#var obj = scene.instantiate()
	#add_child(obj, true)

func view():
	var inventory_ui = inventory_ui_scene.instantiate()
	inventory_ui.inventory = self
	return inventory_ui
