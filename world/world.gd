extends Node3D

class_name World

var god_camera_scene = preload("res://teller/god_camera.tscn")
var rogue_scene = preload("res://character/rogue.tscn")
var wizard_scene = preload("res://character/wizard.tscn")

@onready var spawn = $CharacterSpawn
@onready var characters = $Characters
@onready var objects_spawner = $ObjectsSpawner

func _ready():
	GameObject.setup_objects(objects_spawner)
	
	if multiplayer.is_server():
		for player in MultiplayerController.get_players():
			if player.teller:
				pass
				#var camera = god_camera_scene.instantiate()
				#add_child(camera)
			else:
				var hero = characters.get_children().filter(func(x): return x.hero and not x.player)[0]
				hero.hand_off.rpc(player.id)
				hero.character_name = player.name
				#for hero in heros:
					
				
				
				#var rogue = rogue_scene.instantiate()
				#rogue.name = str(player.id)
				#rogue.global_position = spawn.global_position
				#characters.add_child(rogue)
				#rogue.hand_off.rpc(player.id)
		
	if MultiplayerController.get_local_player().teller:
		var camera = god_camera_scene.instantiate()
		add_child(camera)

@rpc("any_peer", "call_local", "reliable")
func spawn_character(pos: Vector3):
	var character = wizard_scene.instantiate()
	character.global_position = pos
	characters.add_child(character, true)
	character.owner = self
	character.hand_off.rpc(MultiplayerController.get_local_player().id)
	
