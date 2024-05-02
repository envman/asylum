extends Node3D

#@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var name_label = $NameLabel

var player: bool
var character_name: String

# Called when the node enters the scene tree for the first time.
#func _ready():
	#print(get_path())
	#print(sync.root_path)
	#sync.root_path = ^"../.."
	#print(sync.root_path)
	#print("config", sync.replication_config)
	
	#print(sync.replication_config.get_properties())
	#sync.replication_config = SceneReplicationConfig.new()
	#sync.replication_config.add_property(^"Person/NameLabel:text")
	#sync.replication_config.property_set_replication_mode(^"Person/NameLabel:text", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = get_parent().player
	character_name = get_parent().character_name
	
	name_label.visible = !player
	name_label.text = character_name
