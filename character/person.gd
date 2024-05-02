extends Node3D

@onready var sync: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var name_label = $NameLabel

var player: bool
var character_name: String

func _ready():
	sync.root_path = ^"../.."
	
	sync.replication_config = SceneReplicationConfig.new()
	sync.replication_config.add_property(^"Person:character_name")
	sync.replication_config.property_set_replication_mode(^"Person:character_name", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	sync.replication_config.add_property(^"Person/NameLabel:text")
	sync.replication_config.property_set_replication_mode(^"Person/NameLabel:text", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	sync.replication_config.add_property(^".:position")
	sync.replication_config.add_property(^".:rotation")
	sync.replication_config.add_property(^".:current_animation")
	sync.replication_config.property_set_replication_mode(^".:current_animation", SceneReplicationConfig.REPLICATION_MODE_ON_CHANGE)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	player = get_parent().player
	character_name = get_parent().character_name
	
	name_label.visible = !player
	name_label.text = character_name
