extends StaticBody3D

@export var open: bool = false

@onready var openable = $Openable

func _ready():
	openable.open = open
