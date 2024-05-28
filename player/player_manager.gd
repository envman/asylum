extends Node3D

class_name PlayerManager

@onready var player_spawner = $"../PlayerSpawner"

signal player_updated

func _ready():
	#player_spawner.spawned.connect(watch_player)
	child_entered_tree.connect(watch_player)

func watch_player(player):
	#Log.log("watch_player: " + player.player_name)
	#print("watch_player", player.player_name)
	player.property_updated.connect(func(): player_updated.emit())
	player_updated.emit()

func get_tellers():
	return get_children().filter(func(x): return x.teller)

func get_heros():
	return get_children().filter(func(x): return !x.teller)

func get_local():
	return get_children().filter(func(x): return x.id == multiplayer.get_unique_id())[0]
