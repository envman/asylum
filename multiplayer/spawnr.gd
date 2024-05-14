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
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	if ignore.has(node):
		ignore.remove_at(ignore.find(node))
		return
	
	_add_node.rpc(node.scene_file_path, node.name)

@rpc("authority", "reliable")
func _add_node(path: String, object_name: String):
	print("_add_node: ", object_name)
	var scene = load(path)
	var obj = scene.instantiate()
	obj.name = object_name
	
	add_child(obj)
	
func _node_removed(node: Node):
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	if ignore.has(node):
		ignore.remove_at(ignore.find(node))
		return
	
	_remove_node.rpc(node.name)

@rpc("authority", "reliable")
func _remove_node(node_name: String):
	if not has_node(node_name):
		print("TRIED TO REMOVE NON EXISTANT NODE! ", node_name)
		return
		
	var node = get_node(node_name)
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
