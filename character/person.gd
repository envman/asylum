extends Node3D

var camera_controller_scene = preload("res://character/camera/camera_controller.tscn")

@export var camera: CameraController
@export var current_animation: String:
	set(val):
		if playback != null:
			playback.travel(val)	
		current_animation = val

@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var name_label = $NameLabel

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player: bool
var character_name: String
var direction

var state_factory: StateFactory
var state: State

var animation_tree: AnimationTree
var playback

func _ready():
	sync.root_path = ^"../.."
	
	sync.replication_config = SceneReplicationConfig.new()
	sync.replication_config.add_property(^"Person:character_name")
	sync.replication_config.property_set_replication_mode(^"Person:character_name", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	sync.replication_config.add_property(^"Person/NameLabel:text")
	sync.replication_config.property_set_replication_mode(^"Person/NameLabel:text", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	sync.replication_config.add_property(^".:position")
	sync.replication_config.add_property(^".:rotation")
	sync.replication_config.add_property(^"Person:current_animation")
	sync.replication_config.property_set_replication_mode(^"Person:current_animation", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	animation_tree = get_parent().get_node(^"AnimationTree")
	playback = animation_tree.get("parameters/playback")
	
	state_factory = StateFactory.new()
	change_state("idle")
	
func _process(_delta):
	character_name = get_parent().character_name
	
	name_label.visible = !player
	name_label.text = character_name

func _physics_process(delta):
	if not get_parent().is_on_floor():
		get_parent().velocity.y -= gravity * delta
		
	if player:
		var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
		direction = (get_parent().transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	get_parent().move_and_slide()

@rpc("authority", "call_local", "reliable")
func accept_player():
	var cam = camera_controller_scene.instantiate()
	add_child(cam)
	camera = cam
	player = true

@rpc("call_local", "reliable")
func hand_off(id):
	get_parent().set_multiplayer_authority(id)
	var local_player = MultiplayerController.get_local_player()
	local_player.character = get_parent().get_path()
	print("character set to", local_player.character)
	
	if local_player.id == id and not local_player.teller:
		accept_player()
		name_label.text = local_player.player_name

var state_name: String

func _on_animation_tree_animation_finished(anim_name):
	state.animation_finished(anim_name)

func change_state(new_state_name):
	if state != null:
		state.exit()
		state.queue_free()
	
	var last_state_name = state_name
	state_name = new_state_name
	state = state_factory.get_state(new_state_name).new()
	state.setup(playback, get_parent(), self, last_state_name)
	state.name = new_state_name
	add_child(state)

func set_animation(animation_name):
	if player:
		current_animation = animation_name
