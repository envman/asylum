extends Node3D

class_name Player

@export var id: int:
	set(val):
		if id != val:
			property_updated_emit.call_deferred()
		
		id = val

@export var player_name: String:
	set(val):
		if player_name != val:
			property_updated_emit.call_deferred()
		
		player_name = val

@export var teller: bool = false:
	set(val):
		if teller != val:
			property_updated_emit.call_deferred()
		
		teller = val

@export var character: NodePath:
	set(val):
		if character != val:
			property_updated_emit.call_deferred()
		
		character = val

@export var master: bool = false:
	set(val):
		if master != val:
			property_updated_emit.call_deferred()
		
		master = val

@export var hero_name: String = "":
	set(val):
		if hero_name != val:
			property_updated_emit.call_deferred()
		
		hero_name = val

signal property_updated

func property_updated_emit():
	property_updated.emit()

func get_character():
	if character == null || character.is_empty():
		return null
	
	return get_node(character)
