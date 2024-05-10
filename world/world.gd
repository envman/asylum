extends Node3D

class_name World

var god_camera_scene = preload("res://teller/god_camera.tscn")
var rogue_scene = preload("res://character/rogue/rogue.tscn")
var wizard_scene = preload("res://character/wizard/wizard.tscn")

@onready var spawn = $CharacterSpawn
@onready var characters = $Characters
@onready var objects_spawner = $NavigationRegion/ObjectsSpawner
@onready var objects = $NavigationRegion/Objects
@onready var navigation_region = $NavigationRegion

func _ready():
	GameObject.setup_objects(objects_spawner)
	
	if multiplayer.is_server():
		var free_characters: Array = characters.get_free_heros()
		
		for player in MultiplayerController.get_players():
			if not player.teller:
				#var hero = characters.get_free_hero()
				var hero = free_characters.pop_front()
				hero.get_node(^"CharacterModule").hand_off.rpc(player.id)
				hero.get_node(^"CharacterModule").character_name = player.player_name
		
	if MultiplayerController.get_local_player().teller:
		var camera = god_camera_scene.instantiate()
		add_child(camera)
	else:
		for level in navigation_region.get_children():
			if "visible" in level:
				level.visible = true

@rpc("any_peer", "call_local", "reliable")
func spawn_character(pos: Vector3):
	var character = wizard_scene.instantiate()
	character.global_position = pos
	characters.add_child(character, true)
	character.owner = self
	character.hand_off.rpc(MultiplayerController.get_local_player().id)
	

func bake_navigation_mesh():
	navigation_region.bake_navigation_mesh(true)
