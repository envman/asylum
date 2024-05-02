extends Action

func _ready():
	get_parent().state_changed.connect(_state_changed)

func _state_changed(open: bool):
	if open:
		action_name = "Close"
	else:
		action_name = "Open"
