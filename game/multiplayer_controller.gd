extends Node

@onready var main = $/root/Main
@onready var main_menu = $/root/Main/MainMenu
@onready var players = $/root/Main/Players

var player_name: String

var lobby_scene = preload("res://menu/lobby.tscn")
var player_scene = preload("res://player/player.tscn")

var log = []


signal player_joined
signal player_left

func _ready():
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)

func _peer_connected(id: int):
	_log("Player Connected: " + str(id))
	if multiplayer.is_server():
		pass
		#_send_players()

func _peer_disconnected(id: int):
	_log("Player Disconnected: " + str(id))
	player_left.emit(id)
	#if multiplayer.is_server():
		

func _connected_to_server():
	_log("Connected to server")
	
	join_lobby()

func _connection_failed():
	_log("Connection failed")

func _log(text: String):
	log.append(text)
	print(text)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc("any_peer", "call_local", "reliable")
func add_player(id, name):
	print("add_player: " + str(id) + " - " + name)
	
	var player = player_scene.instantiate()
	player.name = str(id)
	player.id = id
	player.player_name = name
	
	if OS.is_debug_build():
		player.teller = multiplayer.get_remote_sender_id() == 1
		
	players.add_child(player)
	
	#players.append({
		#"id": id,
		#"name": name
	#})
	#
	#player_joined.emit(id, name)
	#load_player_details.rpc(id, name)

func get_player_name(id: int):
	var player = players.get_children().filter(func(x): return x.id == id)[0]
	return player.player_name
	#var player = players.filter(func(x): return x.id == id)[0]
	#return player.name

#@rpc("authority", "call_remote", "reliable")
#func load_player_details(id: int, name: String):
	#players.append({
		#"id": id,
		#"name": name
	#})
	#
	#player_joined.emit(id, name)

func join_lobby():	
	add_player.rpc_id(1, multiplayer.get_unique_id(), player_name)

	var lobby = lobby_scene.instantiate()
	lobby.name = "Lobby"
	main.add_child(lobby)
	main.remove_child(main_menu)

func get_local_player():
	return players.get_children().filter(func(x): return x.id == multiplayer.get_unique_id())[0]

func get_players():
	return players.get_children()

func get_player(id: int):
	return players.get_children().filter(func(x): return x.id == id)[0]

#func _send_players():
	#for player in players:
		#load_player_details.rpc(player.id, player.name)

#@rpc("any_peer", "reliable")
