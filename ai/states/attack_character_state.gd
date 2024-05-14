extends State
class_name AttackCharacterState

var damage_scene = preload("res://objects/effects/damage.tscn")

var nav_agent: NavigationAgent3D
var cooldown = 2.0
var cooldown_time = 0
var target
var attack: Attack

func _ready():
	target = context["attack_target"]
	player.velocity = Vector3(0,0,0)
	attack = context["attack"]

func _physics_process(_delta):
	if attack._available():
		player_module.set_animation("Attack")
		attack.hit(null)
	else:
		player_module.change_state("chase")

func animation_finished(_anim_name):
	player_module.set_animation("Idle")

func exit():
	pass
