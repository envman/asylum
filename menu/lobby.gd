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

func _process(_delta):
	var teller_count = players.get_children().filter(func(x): return x.teller == true).size()
	var hero_count = players.get_children().filter(func(x): return x.teller == false).size()
	
	if teller_names.get_child_count() != teller_count or hero_names.get_child_count() != hero_count:
		for x in teller_names.get_children():
			teller_names.remove_child(x)
		
		for x in hero_names.get_children():
			hero_names.remove_child(x)
		
		for player in players.get_children():
			_add_player(player.id, player.player_name, player.teller)
# Called when the node enters the scene tree for the first time.

func _ready():
	start_button.visible = multiplayer.is_server()

func _player_joined(_id, _name):
	pass

func _player_left(_id):
	pass

func _add_player(id, player_name, teller):
	var button = Button.new()
	button.text = player_name
	button.name = str(id)
	
	if multiplayer.is_server():
		button.pressed.connect(func(): _toggle_teller(id))
	
	if teller:
		teller_names.add_child(button)
	else:
		hero_names.add_child(button)

func _toggle_teller(id):
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

@rpc("authority", "call_local", "reliable")
func start_game():
	var world = world_scene.instantiate()
	main.remove_child(lobby)
	main.add_child(world)
	#get_tree().change_scene_to_packed(game_scene)


func _on_to_teller_pressed():
	pass # Replace with function body.
