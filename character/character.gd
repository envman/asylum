extends CharacterBody3D

class_name Character

@export var hero: bool
@export var character_name: String = "Character"

func _ready():
	pass

func _on_animation_tree_animation_finished(anim_name):
	get_node("CharacterModule")._on_animation_tree_animation_finished(anim_name)
