extends State
class_name MoveToState

#var speed = 5.0
var nav_agent: NavigationAgent3D

func _ready():
	player_module.set_animation("Walk")
	nav_agent = context["nav_agent"]
	
	nav_agent.target_reached.connect(target_reached)
	nav_agent.velocity_computed.connect(move_player)

func _physics_process(_delta):
	var next_position: Vector3 = nav_agent.get_next_path_position()
	var direction: Vector3 = player.global_position.direction_to(next_position) * nav_agent.max_speed
	var new_agent_velocity: Vector3 = player.velocity + (direction - player.velocity)
	
	nav_agent.set_velocity(new_agent_velocity)
	
	if context.has("attack_target"):
		if context["attack_target"].global_position.distance_to(player.global_position) < 2:
			nav_agent.target_position = player.global_position
			player_module.change_state("attack_character")

func move_player(new_velocity: Vector3):
	player.velocity = new_velocity
	player.rotation.y = lerp_angle(player.rotation.y, atan2(player.velocity.x, player.velocity.z), 1) + 3.14
	player.move_and_slide()

func target_reached():
	if context.has("attack_target"):
		player_module.change_state("attack_character")
	else:
		player_module.change_state("idle")

func exit():
	nav_agent.target_reached.disconnect(target_reached)
	nav_agent.velocity_computed.disconnect(move_player)
