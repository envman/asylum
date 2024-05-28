extends Node3D
class_name CharacterModule

var camera_controller_scene = preload("res://character/camera/camera_controller.tscn")

@export var camera: CameraController
@export var current_animation: String:
	set(val):
		if playback != null:
			playback.travel(val)	
		current_animation = val

#@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var name_label = $NameLabel
@onready var info_label = $InfoLabel
@onready var sync_me: Sync = $Sync

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: bool
var character_name: String
var direction

var state_factory: StateFactory = StateFactory.new()
var state: State 

var animation_tree: AnimationTree
var playback

var child_ui
var state_context = {}

@export var start_state = "idle"

func _ready():
	sync_me.add_property(get_parent(), "position")
	sync_me.add_property(get_parent(), "rotation")
	sync_me.add_property(get_parent(), "scale")
	sync_me.add_property(self, "character_name", Sync.SYNC_TYPE_CHANGE)
	sync_me.add_property(self, "current_animation", Sync.SYNC_TYPE_CHANGE)
	sync_me.add_property(name_label, "text", Sync.SYNC_TYPE_CHANGE)
	
	animation_tree = get_parent().get_node(^"AnimationTree")
	playback = animation_tree.get("parameters/playback")
	
	if multiplayer.is_server():
		change_state(start_state)
	
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)
	
	if not get_parent().hero:
		character_name = get_parent().character_name

func _process(_delta):	
	name_label.visible = !player
	name_label.text = character_name

	if child_ui != null:
		if Input.is_action_just_pressed("leave"):
			if not "block_exit" in child_ui:
				remove_child_ui()
		return

	if player:
		#if Input.is_action_pressed("crawl"):
			#get_parent().scale.y = .5
		#else:
			#get_parent().scale.y = 1
			
		if Input.is_action_just_pressed("inventory"):
			var inventory_ui = get_node(^"Inventory").view()
			add_child_ui(inventory_ui)

func add_child_ui(scene):
	child_ui = scene
	add_child(child_ui)
	camera.freeze = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if "done" in child_ui:
		child_ui.done.connect(remove_child_ui)

func remove_child_ui():
	remove_child(child_ui)
	child_ui = null
	camera.freeze = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if child_ui != null:
		return
		
	if not get_parent().is_on_floor():
		get_parent().velocity.y -= gravity * delta
		
	if player:
		var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
		direction = (get_parent().transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	get_parent().move_and_slide()

@rpc("authority", "call_local", "reliable")
func accept_player(id):
	print(id, " accept player ", character_name)
	var cam = camera_controller_scene.instantiate()
	add_child(cam)
	camera = cam
	player = true
	var owning_player = MultiplayerController.get_player(id)
	owning_player.character = get_parent().get_path()
	
	# TODO: This is probably needed for controlling
	change_state.call_deferred("idle")

@rpc("authority", "call_local", "reliable")
func release_player(id):
	remove_child(camera)
	camera = null
	player = false
	var owning_player = MultiplayerController.get_player(id)
	owning_player.character = NodePath("")

@rpc("authority", "call_local", "reliable")
func hand_off(id):
	print(multiplayer.get_unique_id(), ": hand_off: ", id)
	
	get_parent().set_multiplayer_authority(id)
	for child in get_children():
		if child is Module or child is Spawnr:
			child.set_multiplayer_authority(1)
	
	var local_player = MultiplayerController.get_local_player()
	var owning_player = MultiplayerController.get_player(id)
	owning_player.character = get_parent().get_path()
	
	if id == multiplayer.get_unique_id():
	#if local_player != null and local_player.id == id and not local_player.teller:
		accept_player(id)
		#name_label.text = local_player.player_name
		#character_name = local_player.player_name

@rpc("any_peer", "call_local", "reliable")
func request_control():
	if get_multiplayer_authority() != 1:
		print("cannot hand off already controlled character")
		return
	
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if not caller.teller:
		print("only tellers can request control")
		return
	
	hand_off.rpc(multiplayer.get_remote_sender_id())

@rpc("authority", "call_local", "reliable")
func release_control():
	#if get_multiplayer_authority() != multiplayer.get_remote_sender_id():
		#print("cannot release character you don't control")
		#return
	#
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if not caller.teller:
		print("only tellers can release control")
		return
		
	get_parent().set_multiplayer_authority(1)
	
	var local_player = MultiplayerController.get_local_player()
	var owning_player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	
	release_player(multiplayer.get_remote_sender_id())
	#if id == multiplayer.get_unique_id():
	#if local_player != null and local_player.id == id and not local_player.teller:
		#accept_player(id)
		#name_label.text = local_player.player_name
		#character_name = local_player.player_name
	

var state_name: String

func _on_animation_tree_animation_finished(anim_name):
	state.animation_finished(anim_name)

@rpc("any_peer", "call_local", "reliable")
func change_state(new_state_name):
	print("change_state called ", new_state_name, " by ", multiplayer.get_remote_sender_id())
	if multiplayer.get_remote_sender_id() != 0:
		var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
		if get_multiplayer_authority() != 1 or not caller.teller:
			return

	print("change_state ", new_state_name)
	if state != null:
		state.exit()
		state.queue_free()
	
	var last_state_name = state_name
	state_name = new_state_name
	state = state_factory.get_state(new_state_name).new()
	state.setup(playback, get_parent(), self, last_state_name)
	state.name = new_state_name
	state.context = state_context
	add_child.call_deferred(state)

func set_animation(animation_name):
	if player or (multiplayer.is_server() and get_multiplayer_authority() == 1):
		current_animation = animation_name

@rpc("any_peer", "call_local", "reliable")
func add_state_context(key, value):
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if get_multiplayer_authority() != 1 or not caller.teller:
		return
	
	state_context[key] = value

@rpc("any_peer", "call_local", "reliable")
func remove_state_context(key):
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if get_multiplayer_authority() != 1 or not caller.teller:
		return
		
	if state_context.has(key):
		state_context.erase(key)
