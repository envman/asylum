extends Node3D

@export var action: Action

signal finished

func _ready():
	action.action_completed.connect(func():
		finished.emit()
	)

func execute():
	action.run()
