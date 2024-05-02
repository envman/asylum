extends Node3D

var motion_blur_scene = preload("res://third-party/motion_blur/motion_blur.tscn")

var blur
var camera_controller

var next_shake = 0
var next_rotation: Vector3

func _ready():
	return
	blur = motion_blur_scene.instantiate()
	camera_controller = get_parent().get_node(^"CameraController")
	var camera = camera_controller.camera
	camera.add_child(blur)

	next_rotation = camera_controller.rotation_degrees

func _process(delta):
	return
	if next_shake <= 0:
		var x = float((randi() % 100) - 50)
		var y = float((randi() % 100) - 50)
		var z = float((randi() % 100) - 50)
		
		next_rotation = Vector3(camera_controller.rotation_degrees.x + x, camera_controller.rotation_degrees.y + y, camera_controller.rotation_degrees.z + z)
		next_shake = randi() % 8
	
	if camera_controller.rotation_degrees != next_rotation:
		camera_controller.rotation_degrees = lerp(camera_controller.rotation_degrees, next_rotation, delta)
	
	next_shake -= delta

func _exit_tree():
	return
	camera_controller.camera.remove_child(blur)
