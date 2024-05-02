extends Module

@export var parent: Node3D
@onready var teller_modules_node = $TellerModules
var teller_modules = []

var nav_agent: NavigationAgent3D

func _ready():
	if parent == null:
		parent = get_parent()

	for node in teller_modules_node.get_children():
		var scene = PackedScene.new()
		scene.pack(node)
		teller_modules.append(scene)
		remove_child(teller_modules_node)
		
	nav_agent = parent.get_node(^"NavigationAgent3D")
	nav_agent.velocity_computed.connect(move_player)

func _physics_process(delta):
	var next_position: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = parent.global_position.direction_to(next_position) * nav_agent.max_speed
	var new_agent_velocity: Vector3 = parent.velocity + (direction - parent.velocity)
	nav_agent.set_velocity(new_agent_velocity)
	#var current_location = parent.global_transform.origin
	#var next_location = nav_agent.get_next_path_position()
	#var new_velocity = (next_location - current_location).normalized() * SPEED
	#
	#parent.velocity = parent.velocity.move_toward(new_velocity, .25)
	#parent.move_and_slide()

func move_player(new_velocity: Vector3):
	#parent.velocity = Vector3(new_velocity.x, 0, new_velocity.z)
	parent.velocity = new_velocity
	#parent.look_at(parent.transform.origin + parent.velocity, Vector3.UP)
	parent.rotation.y = lerp_angle(parent.rotation.y, atan2(parent.velocity.x, parent.velocity.z), 1) + 3.14
	parent.move_and_slide()

func set_target(pos):
	if pos:
		nav_agent.target_position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if target != Vector3.ZERO and parent != null:
		#parent.global_position = target
