extends Node3D

class_name World

var god_camera_scene = preload("res://teller/god_camera.tscn")
var rogue_scene = preload("res://character/rogue/rogue.tscn")
var wizard_scene = preload("res://character/wizard/wizard.tscn")

@onready var characters = $Characters
@onready var objects = $NavigationRegion/Objects
@onready var navigation_region = $NavigationRegion

var heros

func _ready():
	if multiplayer.is_server():
		heros = characters.get_free_heros()
	
	if OS.has_feature("dedicated_server"):
		return
		
	if MultiplayerController.get_local_player().teller:
		var camera = god_camera_scene.instantiate()
		add_child(camera)
	else:
		for level in navigation_region.get_children():
			if "visible" in level:
				level.visible = true
	
	characters.visible = true
	objects.visible = true
	
	if not multiplayer.is_server():
		_find_character.rpc_id(1)

@rpc("any_peer", "call_local", "reliable")
func _find_character():
	#var free_characters: Array = characters.get_free_heros()
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	
	if not player.teller:
		var hero = heros.pop_front()
		print("hand_off: ", hero.name, " to: ", player.player_name)
		hero.get_node(^"CharacterModule").hand_off.rpc(player.id)
		hero.get_node(^"CharacterModule").character_name = player.player_name

func _do_it():
	var free_characters: Array = characters.get_free_heros()
		
	for player in MultiplayerController.get_players():
		if not player.teller:
			#var hero = characters.get_free_hero()
			var hero = free_characters.pop_front()
			print("hand_off: ", hero.name, " to: ", player.player_name)
			hero.get_node(^"CharacterModule").hand_off.rpc(player.id)
			hero.get_node(^"CharacterModule").character_name = player.player_name

@rpc("any_peer", "call_local", "reliable")
func spawn_character(pos: Vector3):
	var character = wizard_scene.instantiate()
	character.global_position = pos
	characters.add_child(character, true)
	character.owner = self
	character.hand_off.rpc(MultiplayerController.get_local_player().id)

func bake_navigation_mesh():
	navigation_region.bake_navigation_mesh(true)

#var time = 5.0
#func _process(delta):
	#if not multiplayer.is_server():
		#return
	##
	#time -= delta
	##
	#if time < 0:
		#_do_it()
		#_called.rpc()
		#
		#time = 1.0
#
#@rpc("authority", "call_local", "reliable")
#func _called():
	#print(multiplayer.get_unique_id(), ": _called")
