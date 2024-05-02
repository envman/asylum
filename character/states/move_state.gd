extends State
class_name MoveState

var speed = 5.0

func _ready():
	player_module.set_animation("Walk")

func _physics_process(_delta):
	if player_module.direction:
		player.velocity.x = player_module.direction.x * speed
		player.velocity.z = player_module.direction.z * speed
		player.rotation_degrees.y = player_module.camera.rotation_degrees.y
		
	else:
		player_module.change_state("idle")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player_module.change_state("jump")
	
	if Input.is_action_just_pressed("attack"):
		player_module.change_state("attack")

func exit():
	pass
