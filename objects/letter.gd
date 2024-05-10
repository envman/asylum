extends StaticBody3D

@export_multiline var text: String

@onready var reading = $Object/Consume/Reading

# Called when the node enters the scene tree for the first time.
func _ready():
	reading.text = text
