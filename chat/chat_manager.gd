extends Node3D

class_name ChatManager

@onready var multiplayer_list = $MultiplayerList

var chat_ui_scene = preload("res://ui/chat_ui.tscn")

var current_chat
var chat_ui

func _process(_delta):
	if current_chat == null:
		var chats = get_chats()

		for chat in chats:
			if chat.player_id == multiplayer.get_unique_id():
				current_chat = chat
				return
	elif chat_ui == null:
		chat_ui = chat_ui_scene.instantiate()
		chat_ui.chat = current_chat
		add_child(chat_ui)
	
	if current_chat != null and chat_ui != null:
		if current_chat.ended:
			remove_child(chat_ui)
			current_chat = null
			chat_ui = null

@rpc("call_local", "any_peer", "reliable")
func start_chat(player_id, player_path, character_path):
	multiplayer_list.add({
		"player_id": player_id,
		"player_path": player_path,
		"character_path": character_path
	})

func get_chats():
	return multiplayer_list.get_items()
