extends Node3D
class_name Sync

static var SYNC_TYPE_FULL = 0
static var SYNC_TYPE_CHANGE = 1

var properties: Array[SyncProp] = []

func _ready():
	_request_state.rpc_id(1)

func _physics_process(_delta):	
	for index in properties.size():
		var property = properties[index]
		var node = property.node
		var prop_name = property.prop_name
		
		if node.get_multiplayer_authority() != multiplayer.get_unique_id():
			continue
		
		var val = node[prop_name]
		
		if property.sync_type == SYNC_TYPE_FULL:
			_send.rpc(index, val)
		elif property.sync_type == SYNC_TYPE_CHANGE:
			if val != property.last_value:
				_changed.rpc(index, val)
				property.last_value = val

@rpc("any_peer", "call_local", "reliable")
func _request_state():
	for index in properties.size():
		var property = properties[index]
		var node = property.node
		var prop_name = property.prop_name
		
		if node.get_multiplayer_authority() != multiplayer.get_unique_id():
			continue
			
		var val = node[prop_name]
		
		if property.sync_type == SYNC_TYPE_CHANGE:
			_changed.rpc_id(multiplayer.get_remote_sender_id(), index, val)

@rpc("authority", "call_local", "unreliable_ordered")
func _send(index: int, val: Variant):
	var prop = properties[index]
	_update_prop(prop, val)

@rpc("authority", "call_local", "reliable")
func _changed(index: int, val: Variant):
	var prop = properties[index]
	_update_prop(prop, val)
	
func _update_prop(prop: SyncProp, val: Variant):
	var node = prop.node
	var prop_name = prop.prop_name
	node[prop_name] = val

func add_property(node: Node, prop_name, sync_type = SYNC_TYPE_FULL):
	var prop = SyncProp.new()
	
	prop.node = node
	prop.prop_name = prop_name
	prop.sync_type = sync_type
	
	properties.append(prop)
