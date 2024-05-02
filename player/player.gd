extends Node3D

class_name Player

@export var id: int
@export var player_name: String
@export var teller: bool = false
@export var character: NodePath


func get_character():
	return get_node(character)
