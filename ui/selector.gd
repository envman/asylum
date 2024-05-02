extends Button

@onready var parent = $".."

func on_pressed():
	Selection.select(parent)

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
