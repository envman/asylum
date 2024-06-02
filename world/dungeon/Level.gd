extends Node3D
class_name Level

@onready var floors: GridMap = $Floors
@onready var walls: GridMap = $Walls

@rpc("any_peer", "call_local", "reliable")
func remove(pos: Vector3i):
	walls.set_cell_item(pos, GridMap.INVALID_CELL_ITEM)

# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_map = TileMap.new()
	tile_map.set_cell(0, Vector2i(0, 0), 1)
	
	print("source_id")
	print(tile_map.get_cell_source_id(0, Vector2i(0,0)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
