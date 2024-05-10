extends Control

signal done

var block_exit = true
var skill_check

@onready var title := $Title
@onready var difficulty := $VBoxContainer/Difficulty
@onready var roll_label := $VBoxContainer/Roll
@onready var result := $VBoxContainer/Result
@onready var check := $HBoxContainer/Check
@onready var finish := $HBoxContainer/Finish

func _process(_delta):
	title.text = skill_check.skill_text() +  " check"
	difficulty.text = "Difficulty: " + str(skill_check.difficulty)
	roll_label.text = "Roll: " + str(skill_check.roll)
	
	if skill_check.finished:
		if skill_check.roll >= skill_check.difficulty:
			result.text = "Passed!"
			result.add_theme_color_override("font_color", Color.WEB_GREEN)
		else:
			result.text = "Failed!"
			result.add_theme_color_override("font_color", Color.DARK_RED)
		
		finish.visible = true

func _on_check_pressed():
	skill_check.start_roll.rpc_id(1)
	check.visible = false

func _on_finish_pressed():
	done.emit()
