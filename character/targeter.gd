extends Node3D
class_name Targeter

@onready var ray: RayCast3D = $RayCast3D

#var highlight_scene = preload("res://module/highlight.tscn")
var selected_ring_scene: PackedScene = preload("res://character/selected_ring.tscn")

var highlight
var target
var hit_pos
var hit_normal

func _physics_process(_delta):	
	var collider = ray.get_collider()
	
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		target = collider
		hit_pos = ray.get_collision_point()
		hit_normal = ray.get_collision_normal()
		return
	
	if target != collider and highlight != null:
		target.remove_child(highlight)
		highlight.queue_free()
	
	if collider != null and collider is Character and target != collider:
		highlight = selected_ring_scene.instantiate()
		highlight.name = "SelectedRing"
		#highlight.target = true
		collider.add_child(highlight)

	target = collider
	hit_pos = ray.get_collision_point()
	hit_normal = ray.get_collision_normal()
