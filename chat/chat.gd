extends Node3D

class_name Chat

@onready var message_list = $MessageList

@export var player_id: int
@export var player_path: String
@export var character_path: String
@export var ended: bool

var message_scene = preload("res://chat/chat_message.tscn")

func get_messages():
	return message_list.get_items()

@rpc("any_peer", "call_local", "reliable")
func send_message(message: String):
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	var sender = player.player_name
	
	if player.teller:
		var character = get_node(character_path)
		sender = character.character_name
	
	message_list.add({ "message": message, "sender": sender })

@rpc("any_peer", "call_local", "reliable")
func end(message: String):
	var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	var sender = player.player_name
	
	if player.teller:
		var character = get_node(character_path)
		sender = character.character_name
	
	message_list.add({ "message": message, "sender": sender })
	
	ended = true
