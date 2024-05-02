extends Node3D

class_name PlayerManager

func get_tellers():
	return get_children().filter(func(x): return x.teller)

func get_heros():
	return get_children().filter(func(x): return !x.teller)

func get_local():
	return get_children().filter(func(x): return x.id == multiplayer.get_unique_id())[0]
