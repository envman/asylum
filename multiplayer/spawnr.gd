extends Node3D
class_name Spawnr

var ignore = []

func _ready():
	child_entered_tree.connect(_node_added)
	child_exiting_tree.connect(_node_removed)
	
	# TODO: ask for update on recent join

func add_copy(node: Node):
	var scene = load(node.scene_file_path)
	var obj = scene.instantiate()
	
	var props = PropHelper.list_exported_props(node)
	for prop in props:
		obj[prop] = node[prop]
	
	add_child(obj, true)
	return obj

func _node_added(node: Node):
	print("node added: ", node.name)
	# TODO: Should I have whitelist?
	
	var player = MultiplayerController.get_local_player()
	var teller = player != null and player.teller
	
	if not teller and not multiplayer.is_server():
		return
	
	if ignore.has(node):
		ignore.remove_at(ignore.find(node))
		return
	
	print("calling _add_node ", node.name)
	node.set_multiplayer_authority(multiplayer.get_unique_id())
	_add_node.rpc(node.scene_file_path, node.name)

func release_node(node):
	print("release_node")
	node.release_authority.rpc()

@rpc("any_peer", "reliable")
func _add_node(scene_path: String, object_name: String):
	print("_add_node ", object_name, " ", scene_path)
	
	var remote = multiplayer.get_remote_sender_id()
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if remote != 1 and not caller.teller:
		return
	
	print("_add_node: ", object_name)
	var scene = load(scene_path)
	var obj = scene.instantiate()
	obj.name = object_name
	obj.set_multiplayer_authority(multiplayer.get_remote_sender_id())
	
	if multiplayer.is_server():
		print("Node added elsewhere, claiming authority ", object_name)
		
		var base = obj
		if GameObject.is_game_object(obj):
			base = GameObject.object(obj)
		
		if base.has_node(^"Sync"):
			var sync: Sync = base.get_node(^"Sync")
			sync.full_sync_completed.connect(release_node.bind(obj))
				
		else:
			release_node(base)
	
	ignore.append(obj)
	add_child(obj)
	
func _node_removed(node: Node):
	print("_node_removed: ", node.name)
	
	var player = MultiplayerController.get_local_player()
	var teller = player != null and player.teller
	
	if not teller and not multiplayer.is_server():
		return
	
	if ignore.has(node):
		ignore.remove_at(ignore.find(node))
		return
	
	_remove_node.rpc(node.name)

@rpc("any_peer", "reliable")
func _remove_node(node_name: String):
	print("_remove_node: ", node_name)
	
	var remote = multiplayer.get_remote_sender_id()
	var caller = MultiplayerController.get_player(multiplayer.get_remote_sender_id())
	if remote != 1 and not caller.teller:
		return
	
	if not has_node(node_name):
		print("TRIED TO REMOVE NON EXISTANT NODE! ", node_name)
		return
		
	var node = get_node(node_name)
	ignore.append(node)
	remove_child(node)

func move(node: Node):
	if not multiplayer.is_server():
		return
	
	ignore.append(node)
	
	var parent = node.get_parent()
	if parent is Spawnr:
		parent.ignore.append(node)
		
	_move_node.rpc(node.get_path())

@rpc("authority", "call_local", "reliable")
func _move_node(node_path: NodePath):
	var node = get_node(node_path)
	var parent = node.get_parent()
	parent.remove_child(node)
	
	var sel = self
	
	sel.add_child(node)
