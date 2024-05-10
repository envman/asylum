extends Node
class_name GameObject

static func is_game_object(obj: Node) -> bool:
	for child in obj.get_children():
		if child is GameObject:
			return true
			
	return false

static func object(obj: Node) -> GameObject:
	for child in obj.get_children():
		if child is GameObject:
			return child
	
	return null

static func setup_objects(multiplayer_spawner: MultiplayerSpawner) -> void:
	var dir := DirAccess.open("res://objects")
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tscn"):
			var path = "res://objects/" + file_name
			var obj_scene: PackedScene = load(path)
			var obj = obj_scene.instantiate()
			
			if GameObject.is_game_object(obj):
				multiplayer_spawner.add_spawnable_scene(path)

		file_name = dir.get_next()

@export var object_name: String

@onready var sync = $MultiplayerSynchronizer
@onready var label = $Label3D

func _ready():
	#var p = get_parent()
	
	sync.root_path = ^"../.."
	
	var config: SceneReplicationConfig = sync.replication_config
	#config.add_property(str(get_path()) + ":position")
	config.add_property(^".:position")
	config.add_property(str(label.get_path()) + ":text")
	#config.add_property(^"Object/Label3D:text")
	config.property_set_replication_mode(str(label.get_path()) + ":text", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	#config.property_set_replication_mode(^"Object/Label3D:text", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	
	label.text = object_name
	if get_parent().has_node(^"Model"):
		label.visible = false
		
	var inventory = get_parent().get_parent()
	if inventory is Inventory:
		if get_parent().has_node("CollisionShape3D"):
			var collision: CollisionShape3D = get_parent().get_node("CollisionShape3D")
			collision.disabled = true
	
func _exit_tree():
	var config = sync.replication_config
	config.remove_property(^".:position")
	config.remove_property(str(label.get_path()) + ":text")
	#for prop in sync.replication_config.get_property_list():
		#print(prop)
	#sync
	#multiplayer.object_configuration_remove(sync)
	sync.queue_free()
	
