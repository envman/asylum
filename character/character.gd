extends CharacterBody3D

class_name Character

var camera_controller_scene = preload("res://character/camera_controller.tscn")

@onready var name_label = $NameLabel
@onready var animation_tree = $AnimationTree
#@onready var front_ray = $InFrontRay
@onready var playback = animation_tree.get("parameters/playback")

@export var player: bool = false
@export var camera: CameraController
@export var model: Node3D
@export var hero: bool = false

@export var current_animation: String:
	set(val):
		if playback != null:
			playback.travel(val)	
		current_animation = val

@export var character_name: String

const SPEED = 5.0
const JUMP_VELOCITY = 500

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var state
var state_factory
var direction
var looking_at: Node3D

#enum Model

func _ready():
	state_factory = StateFactory.new()
	change_state("idle")

func _process(delta):
	name_label.visible = !player
	name_label.text = character_name

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if player:
		var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		#direction = direction.rotated(Vector3.UP, rotation.y)
		
		#if front_ray.is_colliding():
			#looking_at = front_ray.get_collider()
		#else:
			#looking_at = null

	move_and_slide()

var state_name: String

func change_state(new_state_name):
	if state != null:
		state.exit()
		state.queue_free()
	
	var last_state_name = state_name
	state_name = new_state_name
	state = state_factory.get_state(new_state_name).new()
	state.setup(playback, self, last_state_name)
	state.name = new_state_name
	add_child(state)


func _on_animation_tree_animation_finished(anim_name):
	state.animation_finished(anim_name)

@rpc("authority", "call_local", "reliable")
func accept_player():
	var cam = camera_controller_scene.instantiate()
	add_child(cam)
	camera = cam
	player = true

func set_animation(name):
	if player:
		current_animation = name

@rpc("call_local", "reliable")
func hand_off(id):
	set_multiplayer_authority(id)
	var player = MultiplayerController.get_local_player()
	player.character = get_path()
	print("character set to", player.character)
	
	if player.id == id and not player.teller:
		accept_player()
		name_label.text = player.player_name
