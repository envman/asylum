extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var skele = get_parent()
	var bone_id = skele.find_bone("handIK.r")
	#for b in skele.get_children():
		#print(b.name)
	#print(get_parent().find_bone("handIK.r")) #38
	transform = get_parent().get_bone_global_pose(bone_id)
	rotation_degrees.z += 90
	
