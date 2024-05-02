extends Node3D

func get_free_hero():
	var heros = get_heros()
	var free = heros.filter(filter_free)
	
	if free.size() > 0:
		return free[0]

func get_heros():
	return get_children().filter(filter_hero)
	
func filter_hero(character):
	return character.hero

func filter_free(character):
	var character_module = character.get_node(^"Person")
	return !character_module.player
