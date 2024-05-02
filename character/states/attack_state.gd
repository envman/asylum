extends State
class_name AttackState

func _ready():
	
	player.set_animation("Attack")
	player.velocity.x = 0
	player.velocity.z = 0

func _physics_process(delta):
	player.get_node("AnimationTree").advance(delta * 2)

func animation_finished(name):
	player.change_state("idle")

func exit():
	pass
