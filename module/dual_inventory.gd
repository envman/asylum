extends Control

@onready var left = $HSplitContainer/InventoryUI
@onready var right = $HSplitContainer/InventoryUI2

var left_inventory
var right_inventory

var left_name
var right_name

func set_objects(a, b):
	left_inventory = a
	right_inventory = b

func _ready():
	left.inventory = left_inventory
	left.other_container = right_inventory
	
	right.inventory = right_inventory
	right.other_container = left_inventory
	
	left.title = left_name
	right.title = right_name

#func _process(delta):
	#if Input.is_action_just_pressed("leave"):
		##Input.mouse_mode
		#queue_free()
