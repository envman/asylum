extends Control

@onready var heros_list = $HSplitContainer/Heros

var heros

# Called when the node enters the scene tree for the first time.
func _ready():
	heros = Load.find_all_with_filter("character", func(x): return x is Character and x.hero, true)
	
	for hero in heros_list.get_children():
		heros_list.remove_child(hero)
	
	for hero in heros:
		var button = Button.new()
		button.text = hero.name
		heros_list.add_child(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
