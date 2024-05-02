extends Camera3D


var freeze = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(delta):
	if freeze:
		return
	
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	global_position.x += direction.x * 0.5
	global_position.z += direction.z * 0.5
	#velocity.x = player.direction.x * player.SPEED
	#velocity.z = player.direction.z * player.SPEED
