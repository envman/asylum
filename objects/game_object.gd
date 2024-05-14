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
@export var inventory: bool = true
@export var heavy: bool = false
@export var held: bool = false

@onready var sync_me: Sync = $Sync
@onready var label = $Label3D

func _ready():
	sync_me.add_property(get_parent(), "position")
	sync_me.add_property(label, "text", Sync.SYNC_TYPE_CHANGE)
	
	var parent_props = PropHelper.list_exported_props(get_parent())
	for prop in parent_props:
		sync_me.add_property(get_parent(), prop, Sync.SYNC_TYPE_CHANGE)
	
	label.text = object_name
	if get_parent().has_node(^"Model"):
		label.visible = false
		
	var inventory = get_parent().get_parent()
	if inventory is Inventory:
		if get_parent().has_node("CollisionShape3D"):
			var collision: CollisionShape3D = get_parent().get_node("CollisionShape3D")
			collision.disabled = true
