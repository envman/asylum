extends Control

@onready var name_edit = $Name
@onready var error_label = $Error
@onready var host_button = $Panel/VBoxContainer/Host

var PORT = 1337
var LOCAL_IP_ADDRESS = "127.0.0.1"
var IP_ADDRESS = "3.9.134.31"
var MAX_CLIENTS = 8

func _ready():
	host_button.visible = MultiplayerController.local_testing

var ran = false
func _process(_delta):
	if not ran and MultiplayerController.local_testing:
		var server = host()
		if not server:
			print("not server, joining")
			join()
		else:
			print("I AM SERVER")
			
		ran = true

	if not ran:
		if OS.has_feature("dedicated_server"):
			print("Is dedicated server")
			host(true)
		ran = true

func host(server = false):
	if not server:
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
	var ip_address = IP_ADDRESS
	if MultiplayerController.local_testing:
		ip_address = LOCAL_IP_ADDRESS

	var error = peer.create_client(ip_address, PORT)
	
	if error != OK:
		print("Error connecting to server!" +  error)
		return
	
	print("connected")
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

func _on_exit_pressed():
	get_tree().quit()

func _get_name():				
	if name_edit.text.length() < 3:
		if OS.is_debug_build() and MultiplayerController.local_testing:
			var p_name = "TEST " + str(randi())
			MultiplayerController.player_name = p_name
			return p_name
		
		error_label.text = "Name must be 3 or more characters!"
		return
	
	MultiplayerController.player_name = name_edit.text
	return name_edit.text
