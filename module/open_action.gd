extends Action

func _ready():
	get_parent().state_changed.connect(_state_changed)
	
	if "change_completed" in get_parent():
		get_parent().change_completed.connect(func():
			action_completed.emit()
		)

func _state_changed(open: bool):
	if open:
		action_name = "Close"
	else:
		action_name = "Open"
