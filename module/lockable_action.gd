extends Action

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var locked = false

func set_locked(val):
	locked = val
	if locked:
		action_name = "Locked"
	if not locked:
		action_name = get_child(0).action_name

@rpc("any_peer", "call_local", "reliable")
func act():
	if locked:
		return
	
	for action in get_children():
		action.act()
