extends Node3D
class_name CharacterModule

var camera_controller_scene = preload("res://character/camera/camera_controller.tscn")

@export var camera: CameraController
@export var current_animation: String:
	set(val):
		if playback != null:
			playback.travel(val)	
		current_animation = val

@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var name_label = $NameLabel
@onready var info_label = $InfoLabel

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

func _ready():
	print("Character_module ready: ", get_parent().name)
	sync.root_path = ^"../.."
	
	sync.replication_config = SceneReplicationConfig.new()
	sync.replication_config.add_property(^"CharacterModule:character_name")
	sync.replication_config.property_set_replication_mode(^"CharacterModule:character_name", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	sync.replication_config.add_property(^"CharacterModule/NameLabel:text")
	sync.replication_config.property_set_replication_mode(^"CharacterModule/NameLabel:text", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	sync.replication_config.add_property(^".:position")
	sync.replication_config.add_property(^".:rotation")
	sync.replication_config.add_property(^".:scale")
	sync.replication_config.add_property(^"CharacterModule:current_animation")
	sync.replication_config.property_set_replication_mode(^"CharacterModule:current_animation", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	animation_tree = get_parent().get_node(^"AnimationTree")
	playback = animation_tree.get("parameters/playback")
	
	change_state("idle")
	
	animation_tree.animation_finished.connect(_on_animation_tree_animation_finished)
	
func _process(_delta):	
	name_label.visible = !player
	name_label.text = character_name

	if child_ui != null:
		if Input.is_action_just_pressed("leave"):
			if not "block_exit" in child_ui:
				remove_child_ui()
		return

	if player:
		if Input.is_action_pressed("crawl"):
			get_parent().scale.y = .5
		else:
			get_parent().scale.y = 1
			
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
	var cam = camera_controller_scene.instantiate()
	add_child(cam)
	camera = cam
	player = true
	var owning_player = MultiplayerController.get_player(id)
	owning_player.character = get_parent().get_path()

@rpc("authority", "call_local", "reliable")
func release_player(id):
	remove_child(camera)
	camera = null
	player = false
	var owning_player = MultiplayerController.get_player(id)
	owning_player.character = NodePath("")

@rpc("call_local", "reliable")
func hand_off(id):
	get_parent().set_multiplayer_authority(id)
	for child in get_children():
		if child is Module or child is Spawner:
			child.set_multiplayer_authority(1)
	
	var local_player = MultiplayerController.get_local_player()
	var owning_player = MultiplayerController.get_player(id)
	owning_player.character = get_parent().get_path()
	
	if local_player.id == id and not local_player.teller:
		accept_player(id)
		name_label.text = local_player.player_name
		character_name = local_player.player_name

var state_name: String

func _on_animation_tree_animation_finished(anim_name):
	state.animation_finished(anim_name)

@rpc("any_peer", "call_local", "reliable")
func change_state(new_state_name):
	if state != null:
		state.exit()
		state.queue_free()
	
	var last_state_name = state_name
	state_name = new_state_name
	state = state_factory.get_state(new_state_name).new()
	state.setup(playback, get_parent(), self, last_state_name)
	state.name = new_state_name
	state.context = state_context
	add_child(state)

func set_animation(animation_name):
	if player or (multiplayer.is_server() and get_multiplayer_authority() == 1):
		current_animation = animation_name
