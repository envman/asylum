extends Effect

@export var duration: float = 5

var black_out_scene = preload("res://objects/effects/black_out.tscn")
var black_out

func client_start(local):
	if not local:
		return
	
	black_out = black_out_scene.instantiate()
	add_child(black_out)

	#character_module.change_state("lie")


func client_process(local, delta):
	if not local:
		return
	


func server_start():
	character_module.change_state.rpc_id(character_module.get_multiplayer_authority(), "lie")

func server_process(delta):
	duration -= delta

	if duration < 0:
		character_module.change_state.rpc_id(character_module.get_multiplayer_authority(), "idle")
		queue_free()
