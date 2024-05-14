extends State
class_name GuardState

func _ready():
	player_module.set_animation("Idle")
	
	var damageable = player_module.get_node(^"Damagable")
	damageable.damage_taken.connect(character_hit)

func character_hit(amount, character):
	player_module.state_context["attack_target"] = character
	player_module.change_state("chase")

func move_pressed():
	return player_module.direction != Vector3.ZERO
	#return Input.is_action_pressed("walk_down") or Input.is_action_pressed("walk_up") or Input.is_action_pressed("walk_right") or Input.is_action_pressed("walk_left")

func _physics_process(_delta):
	#player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	#player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	player.velocity.x = 0.0
	player.velocity.z = 0.0
	
	if not player_module.player:
		return
	
	if move_pressed():
		player_module.change_state("move")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player_module.change_state("jump")
	if Input.is_action_just_pressed("attack"):
		player_module.change_state("attack")
	
	if Input.is_action_just_pressed("test"):
		player_module.change_state("lie")
	

func exit():
	pass
