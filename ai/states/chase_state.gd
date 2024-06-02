extends State
class_name ChaseState

var nav_agent: NavigationAgent3D
var target: Node3D
var attack: Attack

func _ready():
	player_module.set_animation("Walk")
	nav_agent = context["nav_agent"]
	attack = context["attack"]
	
	nav_agent.velocity_computed.connect(move_player)

func _physics_process(_delta):
	if not context.has("attack_target"):
		return
	
	var target = get_node(context["attack_target"])
	nav_agent.target_position = target.global_position
	
	var next_position: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = player.global_position.direction_to(next_position) * nav_agent.max_speed
	var new_agent_velocity: Vector3 = player.velocity + (direction - player.velocity)
	
	nav_agent.set_velocity(new_agent_velocity)
	
	if nav_agent.target_position.distance_to(target.global_position) > 1:
		nav_agent.target_position = target.global_position
	
	if player.global_position.distance_to(target.global_position) < 2:
		player.rotation.y = lerp_angle(player.rotation.y, atan2(target.global_position.x, target.global_position.z ), 1 )
	
	if attack._available():
		player_module.change_state("attack_character")

func move_player(new_velocity: Vector3):
	player.velocity = new_velocity
	player.rotation.y = lerp_angle(player.rotation.y, atan2(player.velocity.x, player.velocity.z), 1) + 3.14
	player.move_and_slide()

func exit():
	nav_agent.velocity_computed.disconnect(move_player)
