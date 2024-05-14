extends Node3D

@onready var torch = $Model
@onready var torch_lit = $ModelLit

@export var lit: bool = false:
	set(val):
		lit = val
		
		torch_lit.visible = lit
		torch.visible = not lit
			

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
