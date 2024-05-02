extends Node3D

@onready var l = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(l.owner)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		var label = Label3D.new()
		label.text = "hello"
		add_child(label)
