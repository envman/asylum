extends State
class_name JumpState

var time

var JUMP_VELOCITY = 100

func _ready():
	player_module.set_animation("Jump")
	time = 0.0

func _physics_process(delta):
	time += delta
	if time > 0.3:
		player.velocity.y += move_toward(player.velocity.y, JUMP_VELOCITY, JUMP_VELOCITY / 50)
	
		if player.is_on_floor():
			player_module.change_state("idle")

func exit():
	pass
