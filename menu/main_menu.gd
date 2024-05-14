extends Control

@onready var name_edit = $Name
@onready var error_label = $Error

var PORT = 1337
var IP_ADDRESS = "127.0.0.1"
var MAX_CLIENTS = 8

var ran = false
func _process(_delta):
	if not ran and OS.is_debug_build():
		var server = host()
		if not server:
			print("not server, joining")
			join()
		else:
			print("I AM SERVER")
			
		ran = true

func host():
	if _get_name() == null:
		return false
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CLIENTS)
	
	if error != OK:
		print("Error starting server! ", error)
		return false
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	
	MultiplayerController.join_lobby()
	print("JOIN LOBBY")
	return true

func join():
	var player_name = _get_name()
	if player_name == null:
		return
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(IP_ADDRESS, PORT)
	
	if error != OK:
		print("Error connecting to server!" +  error)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer

func _on_host_pressed():
	if _get_name() == null:
		return
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CLIENTS)
	
	if error != OK:
		print("Error starting server!" + error)
		return
		
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	
	MultiplayerController.join_lobby()


func _on_join_pressed():
	var player_name = _get_name()
	if player_name == null:
		return
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(IP_ADDRESS, PORT)
	
	if error != OK:
		print("Error connecting to server!" +  error)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	
	#MultiplayerController.join_lobby()


func _on_exit_pressed():
	get_tree().quit()

func _get_name():				
	if name_edit.text.length() < 3:
		if OS.is_debug_build():
			var p_name = "TEST " + str(randi())
			MultiplayerController.player_name = p_name
			return p_name
		
		error_label.text = "Name must be 3 or more characters!"
		return
	
	MultiplayerController.player_name = name_edit.text
	return name_edit.text
