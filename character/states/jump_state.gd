extends State
class_name JumpState

var time

func _ready():
	player.set_animation("Jump")
	time = 0.0

func _physics_process(delta):
	time += delta
	if time > 0.3:
		player.velocity.y += move_toward(player.velocity.y, player.JUMP_VELOCITY, player.JUMP_VELOCITY / 50)
	
		if player.is_on_floor():
			player.change_state("idle")

func exit():
	pass
