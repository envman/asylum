extends Node3D

var highlight_shader = preload("res://module/highlight.gdshader")

var shader

# Called when the node enters the scene tree for the first time.
func _enter_tree():	
	var parent = get_parent()
	var parent_model = parent.get_node(^"Model")
	if not parent_model is MeshInstance3D:
		return
	
	var model: MeshInstance3D = parent_model
	if model != null:
		shader = ShaderMaterial.new()
		shader.shader = highlight_shader
		shader.set_shader_parameter("strength", 0.3)
		model.set_material_overlay(shader)

func _exit_tree():
	if shader != null:
		shader.set_shader_parameter("strength", 0.0)
