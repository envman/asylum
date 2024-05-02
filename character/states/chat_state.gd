extends State
class_name ChatState

@onready var chat_manager: ChatManager = $/root/Main/World/Chats

var chat_ui_scene = preload("res://ui/chat_ui.tscn")

var chat_ui

func _ready():
	player_module.set_animation("Idle")
	
	player_module.camera.freeze = true
	chat_manager.start_chat.rpc_id(1, multiplayer.get_unique_id(), str(player.get_path()), str(player.looking_at.get_path()))

func _physics_process(_delta):
	if not player_module.player:
		return
	
	if Input.is_action_just_pressed("leave"):
		player_module.change_state("idle")

func exit():
	#player.remove_child(chat_ui)
	player_module.camera.freeze = false
