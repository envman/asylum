extends Node3D

@onready var ray = $RayCast3D

var highlight_scene = preload("res://module/highlight.tscn")
var actions_ui_scene = preload("res://ui/actions_ui.tscn")

var selected: Node3D:
	set(val):
		if val != selected:
			if selected != null:
				selected.remove_child(selected.get_node(^"Highlight"))
				remove_ui()
			
			if val != null:
				print("Looking at: ", val.name)
				var highlight = highlight_scene.instantiate()
				highlight.name = "Highlight"
				val.add_child(highlight)
				add_ui(val)
		
		selected = val
		
		if selected == null and action_ui != null:
			remove_ui()

var action_ui

func add_ui(obj):
	print("ADD UI")
	for c in obj.get_children():
		print(c.name)
		if c is Module or c is Object:
			print("Is right")
			for mod_child in c.get_children():
				print(mod_child.name)
				if mod_child is Action:
					print("action")
					if action_ui == null:
						print("ui not null")
						action_ui = actions_ui_scene.instantiate()
						get_parent().add_child(action_ui)
					
					action_ui.add_action(mod_child)

func remove_ui():
	print("REMOVE UI")
	get_parent().remove_child(action_ui)
	action_ui = null
	
func _physics_process(delta):
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	selected = ray.get_collider()
