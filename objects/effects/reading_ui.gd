extends Control

@export var text: String

@onready var label = $Panel/RichTextLabel

func _process(delta):
	if label.text != text:
		label.text = text
