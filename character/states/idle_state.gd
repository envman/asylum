extends State
class_name IdleState

func _ready():
	player.set_animation("Idle")

func move_pressed():
	return Input.is_action_pressed("walk_down") or Input.is_action_pressed("walk_up") or Input.is_action_pressed("walk_right") or Input.is_action_pressed("walk_left")

func _physics_process(_delta):
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	player.velocity.z = move_toward(player.velocity.z, 0, player.SPEED)
	
	if not player.player:
		return
	
	if move_pressed():
		player.change_state("move")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.change_state("jump")
	if Input.is_action_just_pressed("attack"):
		player.change_state("attack")
		
	if player.looking_at is Character and not last_state == "chat":
		player.change_state("chat")
	

func exit():
	pass
