extends State
class_name MoveState

func _ready():
	player.set_animation("Walk")

func _physics_process(delta):
	if player.direction:
		#playback.travel("Walk")
		#animation_player.play("Walking_A")
		
		#player.get_global_transform().basis
		
		#player.add_central_force(Vector3(0, 0, -50) * -player.transform.basis.z)
		player.velocity.x = player.direction.x * player.SPEED
		player.velocity.z = player.direction.z * player.SPEED
		player.rotation_degrees.y = player.camera.rotation_degrees.y
		
	else:
		player.change_state("idle")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("jump")
	
	if Input.is_action_just_pressed("attack"):
		player.change_state("attack")

func exit():
	pass
