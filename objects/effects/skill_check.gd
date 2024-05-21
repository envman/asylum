extends Effect
class_name SkillCheck

enum Skill {
	Strength,
	Dexterity,
	Inteligence,
	Charisma,
	Deception
}

@export var skill: Skill
@export var difficulty: int = 5

@export var roll: int = 0
@export var finished: bool = false

@onready var sync = $Sync

var rolling := false
var roll_time := 0.0
var roll_step = .001
var roll_step_adjustment = .001
var next_step = 0

var skill_check_ui_scene = preload("res://objects/effects/skill_check_ui.tscn")

func _ready():
	sync.add_property(self, "skill", Sync.SYNC_TYPE_CHANGE)
	sync.add_property(self, "difficulty", Sync.SYNC_TYPE_CHANGE)
	sync.add_property(self, "roll", Sync.SYNC_TYPE_CHANGE)
	sync.add_property(self, "finished", Sync.SYNC_TYPE_CHANGE)
	
	super._ready()

func client_start():
	if not local:
		return
	
	var skill_check_ui = skill_check_ui_scene.instantiate()
	skill_check_ui.skill_check = self
	character_module.add_child_ui(skill_check_ui)

func client_process(_delta):
	if not local:
		character_module.info_label.visible = true
		
		# check if passed, make clearer to teller
		if finished:
			if roll >= difficulty:
				character_module.info_label.text = "Passed: " + str(roll)
			else:
				character_module.info_label.text = "Failed: " + str(roll)
		else:
			character_module.info_label.text = "Rolling: " + str(roll)

func server_process(delta):
	if rolling:
		roll_time -= delta
		roll_step -= delta
		
		if roll_step < 0:
			roll = randi() % 20
			print("roll_step ", roll)
			roll_step_adjustment += .1
			roll_step = roll_step_adjustment
			
		if roll_time < 0:
			print("rolling_finished ", roll)
			rolling = false
			finished = true

func skill_text():
	return Skill.keys()[skill]

func copy_to(obj):
	obj.skill = skill
	obj.difficulty = difficulty

@rpc("any_peer", "call_local", "reliable")
func start_roll():
	print("start_roll")
	if finished:
		return
		
	if not multiplayer.is_server():
		return
	
	print("multiplayer_authority: ", get_multiplayer_authority())
	
	rolling = true
	roll_time = 5.0

	roll_step = .001
	roll_step_adjustment = .001
	next_step = 0
	roll = 0
