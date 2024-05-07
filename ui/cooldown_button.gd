extends MarginContainer

@onready var button = $Button
@onready var progress_bar = $ProgressBar

var text: String
var cooldown: float = 2
var available: bool = true:
	set(val):
		available = val
		button.disabled = !val

var cooldown_time = 0.0

func _ready():
	button.text = text

func _process(delta):
	if cooldown_time > 0:
		cooldown_time -= delta
		
		progress_bar.value = (cooldown_time / cooldown) * 100

func can_fire():
	return cooldown_time <= 0

func _on_test_pressed():
	cooldown_time = cooldown

func click():
	cooldown_time = cooldown
