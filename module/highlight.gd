extends Node3D

var highlight_shader = preload("res://module/highlight.gdshader")

var shader
@export var target: bool = false

var meshes = []

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	var parent = get_parent()
	add_meshes(parent)
	
	for mesh in meshes:
		add_highligher(mesh)

func add_highligher(model: MeshInstance3D):
	shader = ShaderMaterial.new()
	shader.shader = highlight_shader
	shader.set_shader_parameter("strength", 0.8)
	shader.set_shader_parameter("target", target)
	model.set_material_overlay(shader)

func remove_highligher(model: MeshInstance3D):
	model.set_material_overlay(null)

func add_meshes(obj):
	if obj is MeshInstance3D:
		meshes.append(obj)
	
	for child in obj.get_children():
		add_meshes(child)

func _exit_tree():
	for mesh in meshes:
		remove_highligher(mesh)
