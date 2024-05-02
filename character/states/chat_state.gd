extends State
class_name ChatState

@onready var chat_manager: ChatManager = $/root/Main/World/Chats

var chat_ui_scene = preload("res://ui/chat_ui.tscn")

var chat_ui

func _ready():
	player.set_animation("Idle")
	
	#chat_ui = chat_ui_scene.instantiate()
	#player.add_child(chat_ui)
	player.camera.freeze = true
	#player.looking_at.
	chat_manager.start_chat.rpc_id(1, multiplayer.get_unique_id(), str(player.get_path()), str(player.looking_at.get_path()))

func _physics_process(_delta):
	if not player.player:
		return
	
	if Input.is_action_just_pressed("leave"):
		player.change_state("idle")

func exit():
	#player.remove_child(chat_ui)
	player.camera.freeze = false
