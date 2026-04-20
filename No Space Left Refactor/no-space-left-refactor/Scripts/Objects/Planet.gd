extends Resource
class_name Planet

var tile_grid: Array[Array] #Stores Structures

@export var size: int = 35 #the 'X' size of the grid

class tile:
	var structure: Structure = null
	var can_construct: bool = true
	var ore: Item
	var ore_richness: int

#region Generation

func gen_tiles():
	tile_grid.resize(size)
	for x in range(size):
		for y in range(2):
			tile_grid[x].resize(2)
			tile_grid[x][y] = tile.new()

#endregion

#region Getters

func get_tile(pos:Vector2i) -> tile:
	var normal_pos: Vector2i = normalize_pos(pos)
	return tile_grid[normal_pos.x][normal_pos.y]

func get_structure(pos:Vector2i) -> Structure:
	return get_tile(pos).structure

#endregion

#region Structure Management

func add_structure(struct: PackedScene, pos: Vector2i):
	var new_struct = struct.instantiate()
	var tile = get_tile(pos)
	
	if tile.structure != null or !tile.can_construct:
		return false
	
	tile.structure = new_struct
	SignalManager.grid_changed.emit(normalize_pos(pos))
	return true

func remove_structure(pos: Vector2i):
	var struct = get_structure(pos)
	if struct != null:
		struct = null
		SignalManager.grid_changed.emit(normalize_pos(pos))
		return true
	
	return false

#endregion

#region Utils

func normalize_pos(pos: Vector2i) -> Vector2i:
	var new_pos: Vector2i = pos
	new_pos.x = new_pos.x % size
	if new_pos.x < 0:
		new_pos.x = size - 1 + new_pos.x
	new_pos.y = clamp(pos.y, 0, 1)
	return new_pos

#endregion
