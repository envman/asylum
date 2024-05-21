extends Control


@onready var main = $/root/Main
@onready var lobby = $/root/Main/Lobby
@onready var players = $/root/Main/Players

@onready var hero_names = $Heros/PlayerNames
@onready var teller_names = $Tellers/PlayerNames


@onready var message_input = $Chat/Message
@onready var chat_lines = $Chat/ChatLines

@onready var start_button = $Start

var world_scene = preload("res://world/world.tscn")

var start_in = 0
var auto_start = false

func _ready():
	#if OS.is_debug_build() and not MultiplayerController.server_testing:
		#print("auto start")
		#start_in = 2.0
		#auto_start = true
		
	if OS.is_debug_build():
		start_button.visible = multiplayer.is_server()

func _process(delta):
	var local_player = MultiplayerController.get_local_player()
	if local_player != null:
		start_button.visible = local_player.master
	
	if auto_start:
		start_in -= delta
		if start_in < 0:
			_on_start_pressed()
	
	var teller_count = players.get_children().filter(func(x): return x.teller == true).size()
	var hero_count = players.get_children().filter(func(x): return x.teller == false).size()
	
	if teller_names.get_child_count() != teller_count or hero_names.get_child_count() != hero_count:
		for x in teller_names.get_children():
			teller_names.remove_child(x)
		
		for x in hero_names.get_children():
			hero_names.remove_child(x)
		
		for player in players.get_children():
			print(player)
			_add_player(player.id, player.player_name, player.teller)

func _player_joined(_id, _name):
	pass

func _player_left(_id):
	pass

func _add_player(id, player_name, teller):
	print("_add_player ", player_name)
	var button = Button.new()
	button.text = player_name
	button.name = str(id)
	
	var local_player = MultiplayerController.get_local_player()
	if local_player != null and local_player.master:
		button.pressed.connect(func(): _toggle_teller(id))
	
	if teller:
		teller_names.add_child(button)
	else:
		hero_names.add_child(button)

func _toggle_teller(id):
	var player = players.get_node(str(id))
	_set_teller.rpc_id(1, id, !player.teller)
	
	#var player = players.get_node(str(id))
	#player.teller = !player.teller

@rpc("any_peer", "call_local", "reliable")
func _set_teller(id, teller):
	var caller = players.get_node(str(multiplayer.get_remote_sender_id()))
	if not caller.master:
		return
	
	var player = players.get_node(str(id))
	player.teller = !player.teller

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
	start_game.rpc()

@rpc("any_peer", "call_local", "reliable")
func start_game():
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if not caller.master:
		return
	
	var world = world_scene.instantiate()
	main.remove_child(lobby)
	main.add_child(world)
	#get_tree().change_scene_to_packed(game_scene)


func _on_to_teller_pressed():
	pass # Replace with function body.
