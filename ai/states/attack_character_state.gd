extends State
class_name AttackCharacterState

var damage_scene = preload("res://objects/effects/damage.tscn")

var nav_agent: NavigationAgent3D
var cooldown = 2.0
var cooldown_time = 0
var target
var attack: Attack

func _ready():
	print("attack_character_state")
	target = context["attack_target"]
	#nav_agent = context["nav_agent"]
	#
	#nav_agent.target_reached.connect(target_reached)
	#nav_agent.velocity_computed.connect(move_player)
	player.velocity = Vector3(0,0,0)
	attack = context["attack"]

func _physics_process(delta):
	if attack._available():
		attack.hit(null)
	else:
		player_module.change_state("chase")
	
	#cooldown_time -= delta

	
	
	#if player.global_position.distance_to(target.global_position) > 2:
		#player_module.change_state("chase")
	#
	#if cooldown_time <= 0:
		#player_module.set_animation("Attack")
		#var damage = damage_scene.instantiate()
		#damage.amount = 50
		#var spawner = target.get_node(^"CharacterModule/Spawner")
		#spawner.add(damage)
		#
		#cooldown_time = cooldown
	#var next_position: Vector3 = nav_agent.get_next_path_position()
	#var direction: Vector3 = player.global_position.direction_to(next_position) * nav_agent.max_speed
	#var new_agent_velocity: Vector3 = player.velocity + (direction - player.velocity)
	#
	#nav_agent.set_velocity(new_agent_velocity)

#func move_player(new_velocity: Vector3):
	#player.velocity = new_velocity
	#player.rotation.y = lerp_angle(player.rotation.y, atan2(player.velocity.x, player.velocity.z), 1) + 3.14
	#player.move_and_slide()

func animation_finished(anim_name):
	player_module.set_animation("Idle")

func exit():
	pass
