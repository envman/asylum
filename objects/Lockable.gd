extends Module

var lockable_action_scene = preload("res://module/lockable_action.tscn")

var lockable

@export var target: Action
@export var locked: bool = true:
	set(val):
		locked = val
		state_changed.emit(val)
		
		if lockable != null:
			lockable.set_locked(locked)

signal state_changed

func _ready():
	var parent = target.get_parent()
	lockable = lockable_action_scene.instantiate()
	lockable.set_locked(locked)
	parent.remove_child(target)
	lockable.add_child(target)
	lockable.action_name = target.action_name
	parent.add_child(lockable)
	target.name_updated.connect(func(x): lockable.action_name = x)

func toggle_lock(player):
	locked = !locked

