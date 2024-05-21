extends Node3D

class_name Player

@export var id: int
@export var player_name: String
@export var teller: bool = false
@export var character: NodePath
@export var master: bool = false


func get_character():
	if character == null || character.is_empty():
		return null
	
	return get_node(character)
