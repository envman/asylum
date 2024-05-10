extends Effect
class_name Damage

var floater_scene = preload("res://ui/floater.tscn")
var highlight_scene = preload("res://module/highlight.tscn")

@export var amount: int = 10

var highlight
var highlight_duration = 0.6

func server_start():
	var damagable = get_parent().get_parent().get_node(^"Damagable")
	damagable.hit(amount)

func client_start():
	var floater = floater_scene.instantiate()
	floater.text = "-" + str(amount)
	character.add_child(floater)
	
	highlight = highlight_scene.instantiate()
	highlight.target = true
	character.add_child(highlight)

func client_process(delta):
	highlight_duration -= delta
	if highlight_duration < 0 and highlight != null:
		character.remove_child(highlight)
		highlight = null
