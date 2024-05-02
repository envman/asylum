extends Node

class_name Log

static func log(str: String):
	var id = MultiplayerController.get_local_player().id
	
	print(str(id) + ":" + str)
