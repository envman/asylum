extends Control

@onready var chat_manager: ChatManager = $/root/Main/World/Chats
@onready var text_entry = $TextEntry
@onready var messages = $Panel/MessageList

var chat: Chat

func _ready():
	messages.get_items = chat.get_messages
	messages.render_item = func(x):
		var i = Label.new()
		i.text = x.sender + ": " + x.message
		return i

func _on_send_pressed():
	chat.send_message.rpc_id(1, text_entry.text)
	text_entry.text = ""


func _on_goodbye_pressed():
	chat.end.rpc_id(1, "Goodbye")

	if chat.player_path != null:
		var player = get_node(chat.player_path)
		print(player)
		player.change_state("idle")
