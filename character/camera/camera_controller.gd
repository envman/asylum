extends Node3D

class_name CameraController

@onready var spring_arm = $SpringArm3D
@onready var parent = $".."
@onready var camera = $SpringArm3D/Camera3D

var sensitivity = 5
var freeze: bool = false:
	set(val):
		freeze = val
		if val:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera.make_current()
	
func _process(delta):
	global_position = $"..".global_position
	

func _input(event):
	if freeze:
		return
	
	if event is InputEventMouseMotion:
		var x_rotation = clamp(rotation.x - event.relative.y / 1000 * sensitivity, -0.5, 0.5)
		var y_rotation = rotation.y - event.relative.x / 1000 * sensitivity
		rotation = Vector3(x_rotation, y_rotation, 0)
		#rotation = Vector3(x_rotation, y_rotation, 0)
		#parent.rotation_degrees.y = y_rotation
		#parent.rotation = Vector3(x_rotation, y_rotation, 0)
		
	if UI.focus:
		return
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			spring_arm.spring_length += 0.1
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			spring_arm.spring_length -= 0.1

	if event is InputEventPanGesture:
		spring_arm.spring_length = clamp(spring_arm.spring_length + event.delta.y, 2, 8)
