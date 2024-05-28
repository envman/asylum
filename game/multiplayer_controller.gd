extends Node

@onready var main = $/root/Main
@onready var main_menu = $/root/Main/MainMenu
@onready var players = $/root/Main/Players

var player_name: String

var lobby_scene = preload("res://menu/lobby.tscn")
var player_scene = preload("res://player/player.tscn")

var local_testing = true
var joined = false

signal player_joined
signal player_left

func _ready():
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.connection_failed.connect(_connection_failed)
	
	#players.player_added.connect(player_added)

func _process(delta):
	if not joined and get_local_player() != null:
		joined = true
		join_lobby()

#func player_added(player):
	#print("player_added")
	#if get_local_player() != null:
		#print("GOT MY PLAYER")
		#join_lobby()
	#else:
		#print("NO PLAYER")

func _peer_connected(id: int):
	_log("Player Connected: " + str(id))
	if multiplayer.is_server():
		pass

func _peer_disconnected(id: int):
	_log("Player Disconnected: " + str(id))
	player_left.emit(id)

func _connected_to_server():
	_log("Connected to server")
	
	network_connected()
	#join_lobby()

func _connection_failed():
	_log("Connection failed")

func _log(text: String):
	print(text)

@rpc("any_peer", "call_local", "reliable")
func add_player(id, player_name):
	print("add_player: " + str(id) + " - " + player_name)
	
	var player = player_scene.instantiate()
	player.name = str(id)
	player.id = id
	player.player_name = player_name
	player.master = players.get_child_count() == 0
	
	if OS.is_debug_build():
		player.teller = multiplayer.get_remote_sender_id() == 1

	if not OS.is_debug_build() and multiplayer.get_remote_sender_id() == 1:
		return
			
	players.add_child(player)

func get_player_name(id: int):
	var player = players.get_children().filter(func(x): return x.id == id)[0]
	return player.player_name

func network_connected():
	if not OS.has_feature("dedicated_server"):
		print("not server so create player")
		add_player.rpc_id(1, multiplayer.get_unique_id(), player_name)

func join_lobby():
	#if not OS.has_feature("dedicated_server"):
		#print("not server so create player")
		#add_player.rpc_id(1, multiplayer.get_unique_id(), player_name)

	var lobby = lobby_scene.instantiate()
	lobby.name = "Lobby"
	main.add_child(lobby)
	main.remove_child(main_menu)

func get_local_player() -> Player:
	if players == null:
		return null
	
	var filtered = players.get_children().filter(func(x): return x.id == multiplayer.get_unique_id())
	if filtered.size() == 0:
		return null
	
	return filtered[0]

func get_players():
	return players.get_children()

func get_player(id: int):
	var all = players.get_children().filter(func(x): return x.id == id)
	if all.size() == 1:
		return all[0]
