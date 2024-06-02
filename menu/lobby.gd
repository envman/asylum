extends Control

@onready var main = $/root/Main
@onready var lobby = $/root/Main/Lobby
@onready var players = $/root/Main/Players

@onready var player_names = $Players/PlayerNames

@onready var characters_panel = $Characters
@onready var character_names = $Characters/CharacterNames

@onready var worlds = $Worlds
@onready var world_names = $Worlds/WorldNames

@onready var message_input = $Chat/Message
@onready var chat_lines = $Chat/ChatLines

@onready var start_button = $Start

var world_scene = preload("res://world/world.tscn")

var start_in = 0
var auto_start = false

var heros
var assigning_character
var selected_world: World

func _ready():
	#var local_player = MultiplayerController.get_local_player()
	#if local_player != null:
		#print("have local player")
	#else:
		#print("NO LOCAL PLAYER")
	
	#if OS.is_debug_build() and not MultiplayerController.server_testing:
		#print("auto start")
		#start_in = 2.0
		#auto_start = true
	
	if OS.is_debug_build():
		start_button.visible = multiplayer.is_server()
	
	load_worlds()
	#load_characters()
	
	players.player_updated.connect(player_updated)
	player_updated()

func load_worlds():
	for world in world_names.get_children():
		world_names.remove_child(world)
	
	var worlds = [world_scene.instantiate()]
	worlds.append_array(Load.find_all_with_filter("worlds", func(x): return x is World, true))
	
	for world in worlds:		
		var button = Button.new()
		button.text = world.name
		button.pressed.connect(func():
			load_characters(world)
			selected_world = world
		)
		world_names.add_child(button)

func player_updated():
	for player in player_names.get_children():
		player_names.remove_child(player)
		
	for player in players.get_children():
		var button = Button.new()
		button.text = player.player_name
		if player.teller:
			button.text += " (TELLER)"
		
		if player.hero_name.length() > 0:
			button.text += " (" + player.hero_name + ")"
		
		button.name = str(player.id)
		
		button.pressed.connect(player_pressed.bind(player))
		
		player_names.add_child(button)
		#_add_player(player.id, player.player_name, player.teller)

func player_pressed(player):
	if assigning_character != null:
		print("assigning_character != null")
		_set_hero_owner.rpc_id(1, player.id, assigning_character.name)
		assigning_character = null
		_set_teller.rpc_id(1, player.id, false)
		return
	
	
	#_set_teller.rpc_id(1, id, !player.teller)
	_set_teller.rpc_id(1, player.id, !player.teller)

func load_characters(w):
	for character in character_names.get_children():
		character_names.remove_child(character)
	#var w = world_scene.instantiate()
	var character_manager = w.get_node("Characters")
	heros = character_manager.get_heros()
	for hero in heros:
		var button = Button.new()
		button.text = hero.name
		button.pressed.connect(character_pressed.bind(hero))
		character_names.add_child(button)

func character_pressed(character):
	print("character_pressed", character.name)
	assigning_character = character

func _process(delta):
	var local_player = MultiplayerController.get_local_player()
	if local_player != null:
		start_button.visible = local_player.master
		worlds.visible = local_player.master or multiplayer.is_server()
	
	if auto_start:
		start_in -= delta
		if start_in < 0:
			_on_start_pressed()
	
	var teller_count = players.get_children().filter(func(x): return x.teller == true).size()
	var hero_count = players.get_children().filter(func(x): return x.teller == false).size()
	
	#if teller_names.get_child_count() != teller_count or hero_names.get_child_count() != hero_count:
		#for x in teller_names.get_children():
			#teller_names.remove_child(x)
		#
		#for x in hero_names.get_children():
			#hero_names.remove_child(x)
		#
		#for player in players.get_children():
			##print(player)
			#_add_player(player.id, player.player_name, player.teller)

func _player_joined(_id, _name):
	pass

func _player_left(_id):
	pass

func _add_player(id, player_name, teller):
	#print("_add_player ", player_name)
	var button = Button.new()
	button.text = player_name
	button.name = str(id)
	
	var local_player = MultiplayerController.get_local_player()
	if multiplayer.is_server() or (local_player != null and local_player.master):
		button.pressed.connect(func(): _toggle_teller(id))
	
	#if teller:
		#teller_names.add_child(button)
	#else:
		#hero_names.add_child(button)

func _toggle_teller(id):
	var player = players.get_node(str(id))
	print("_toggle_teller ", id)
	
	if assigning_character != null:
		print("assigning_character != null")
		_set_hero_owner.rpc_id(1, id, assigning_character.name)
		assigning_character = null
		_set_teller.rpc_id(1, id, false)
		return
	
	
	_set_teller.rpc_id(1, id, !player.teller)
	
	#var player = players.get_node(str(id))
	#player.teller = !player.teller

@rpc("any_peer", "call_local", "reliable")
func _set_hero_owner(id, hero_name):
	var caller = players.get_node(str(multiplayer.get_remote_sender_id()))
	if not caller.master:
		return
	
	var player = players.get_node(str(id))
	player.hero_name = hero_name

@rpc("any_peer", "call_local", "reliable")
func _set_teller(id, teller):
	var caller = players.get_node(str(multiplayer.get_remote_sender_id()))
	if not caller.master and not multiplayer.get_remote_sender_id() == 1:
		return
	
	var player = players.get_node(str(id))
	#print("_set_teller ", player.player_name, " ", teller)
	player.teller = teller

@rpc("any_peer", "call_local", "reliable")
func message(text: String, id: int):
	var player_name = MultiplayerController.get_player_name(id)
	var label = Label.new()
	label.text = player_name + ": " + text
	chat_lines.add_child(label)

func _on_message_text_submitted(text):
	message.rpc(text, multiplayer.get_unique_id())
	message_input.text = ""

func _on_exit_pressed():
	get_tree().quit()

func _on_start_pressed():
	for player in players.get_children():
		if not player.teller and player.hero_name.length() == 0:
			print("player is not setup as teller or hero")
			return
		
	if selected_world == null:
		print("no world selected")
		return
	
	start_game.rpc(selected_world.scene_file_path)

@rpc("any_peer", "call_local", "reliable")
func start_game(scene_path):
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if not caller.master:
		return
	
	var selected_world_scene = load(scene_path)
	var world = selected_world_scene.instantiate()
	world.name = "World"
	main.remove_child(lobby)
	main.add_child(world)
	#get_tree().change_scene_to_packed(game_scene)


func _on_to_teller_pressed():
	pass # Replace with function body.
