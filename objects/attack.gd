extends Action

@export var range: float
@export var state: String = "attack"

var hotbar = true

var cooldown_time = 0

func _process(delta):
	if cooldown_time > 0:
		cooldown_time -= delta
		available = false
	else:
		available = _available()		

func hit(player):
	if cooldown_time > 0:
		print("cooling down")
		return
	
	cooldown_time = cooldown
	
	var target = _get_target()
	if target == null:
		return
	
	var character = _get_character()
	
	var spawner = target.get_node(^"CharacterModule/Spawner")
	if spawner == null:
		print("no spawner")
		return
	
	if character.global_position.distance_to(target.global_position) > range:
		print("out of range")
		return
	
	for child in get_children():
		spawner.add(child)

func _available():
	var character = _get_character()
	var target = _get_target()
	
	if character == null or target == null:
		return false
		
	return character.global_position.distance_to(target.global_position) <= range

func _get_character():
	return get_parent().get_parent().get_parent().get_parent().get_parent()

func _get_target():
	var character_module = get_parent().get_parent().get_parent().get_parent()
	if character_module == null:
		return
	
	var targeter = character_module.get_node(^"Targeter")
	if targeter == null or targeter.target == null:
		return

	return targeter.target
	
