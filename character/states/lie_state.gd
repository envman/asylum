extends State
class_name LieState

#var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	player_module.set_animation("Lie")
	#time = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#time -= delta
	#
	#if time < 0:
		#player_module.change_state("idle")

func exit():
	pass
