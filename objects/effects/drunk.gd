extends Effect
class_name Drunk

var motion_blur_scene = preload("res://third-party/motion_blur/motion_blur.tscn")
var pass_out_effect_scene = preload("res://objects/effects/passout.tscn")

var blur
var camera_controller

var next_shake = 0
var next_rotation: Vector3
@export var time: float = 10

func client_start(local):
	if not local:
		return

	blur = motion_blur_scene.instantiate()
	camera_controller = character_module.get_node(^"CameraController")
	var camera = camera_controller.camera
	camera.add_child(blur)

	next_rotation = camera_controller.rotation_degrees
	
func server_start():
	var drunk_count = get_parent().get_children().filter(func(x): return x is Drunk).size()
	if drunk_count > 4:
		get_parent().add_child(pass_out_effect_scene.instantiate())

func client_process(local, delta):
	if not local:
		return
	
	if time < 0:
		queue_free()
	time -= delta
	
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
	if camera_controller != null:
		camera_controller.camera.remove_child(blur)
	

