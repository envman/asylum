extends Node3D

@onready var skeleton = $"../Model/Rig/Skeleton3D"

func _ready():
	pass # Replace with function body.


func _process(delta):
	if get_child_count() > 0:
		var child = get_child(0)
	
		var bone_id = skeleton.find_bone("handIK.r")
		#for b in skele.get_children():
			#print(b.name)
		#print(get_parent().find_bone("handIK.r")) #38
		child.transform = skeleton.get_bone_global_pose(bone_id)
		child.rotation_degrees.z += -90
