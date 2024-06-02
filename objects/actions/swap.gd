extends Action
class_name Swap

var from: Node
var to: Node

func run():
	var to_node = to.get_path()
	var from_node = from.get_path()
	
	print("move from")
	print(from_node)
	print("to")
	print(to_node)
	to.move_server.rpc_id(1, from_node)
	
	

	#_transfer.rpc_id(1, from_node, to_node)

#@rpc("any_peer", "call_local", "reliable")
#func _transfer(from_path, to_path):
	#print("_transfer")
	#if not multiplayer.is_server():
		#return
	#
	#print("SWAPPING ON SERVER")
	#
	#var from_node = get_node(from_path)
	#var to_node = get_node(to_path)
	#
	#to_node.move(from_node)
	
	
#@rpc("any_peer", "call_local", "reliable")
#func act():

	
	
	
	#var player = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	
	#object.call(method, player)
