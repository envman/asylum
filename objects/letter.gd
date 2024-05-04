extends StaticBody3D

@export_multiline var text: String

@onready var reading = $Object/Consume/Reading

# Called when the node enters the scene tree for the first time.
func _ready():
	reading.text = text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
