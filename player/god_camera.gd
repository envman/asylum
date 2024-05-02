extends Camera3D


var freeze = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(_delta):
	if freeze:
		return
	
	var input_dir = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	global_position.x += direction.x * 0.5
	global_position.z += direction.z * 0.5
	
	if Input.is_action_pressed("rotate_right"):
		rotation_degrees.y -= 2
		
	if Input.is_action_pressed("rotate_left"):
		rotation_degrees.y += 2

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			global_position.y += 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			global_position.y -= 0.1
	
	if event is InputEventPanGesture:
		global_position.y += event.delta.y
