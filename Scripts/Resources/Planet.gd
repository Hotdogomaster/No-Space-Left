extends Resource
class_name Planet

signal array_update(pos:Vector2i)

class tile:
	var structure: Structure = null
	var can_construct: bool = true
	

@export var starchart_position: Vector2

@export var planet_size: int = 35 # entre 30 e 45 
var row0: Array[tile]
var row1: Array[tile]
var structure_grid: Array[Array] = [[], []]

func generate_tiles():
	row0.resize(planet_size)
	row1.resize(planet_size)
	structure_grid[0] = row0
	structure_grid[1] = row1
	for y in structure_grid.size():
		for x in planet_size:
			var new_tile: tile = tile.new()
			structure_grid[y][x] = new_tile
		

func add_structure(type: PackedScene, pos: Vector2i = Vector2i.ZERO):
	var new_structure: Structure = type.instantiate()
	
	if new_structure is Structure:
		new_structure.struct_position = normalize_pos(pos)
		new_structure.planet = self
		
		var new_modules: Array[Module] = []
	
		for m in new_structure.modules:
			var copy = m.duplicate(true)
			new_modules.append(copy)
		new_structure.modules = new_modules
		
		new_structure.recalculate_priority()
		
		if get_tile(pos).can_construct:
			get_tile(pos).structure = new_structure
			
			array_update.emit(normalize_pos(pos))
			
			Global.structures.append(new_structure)
	
func remove_structure(pos: Vector2i = Vector2i.ZERO):
	
	var Gstruct = Global.structures.filter(func(x): return x == get_structure(pos))
	if Gstruct.size() != 0:
		Global.structures.remove_at(Global.structures.find(Gstruct[0]))
	
	get_tile(pos).structure = null
	array_update.emit(normalize_pos(pos))
	

func get_tile(pos: Vector2i) -> tile:
	var new_pos = normalize_pos(pos)
	return structure_grid[new_pos.y][(new_pos.x)] 

func get_structure(pos:Vector2i) -> Structure:
	if get_tile(pos).structure == null:
		return null
	return get_tile(pos).structure

func normalize_pos(pos: Vector2i) -> Vector2i:
	var new_pos: Vector2i = pos
	new_pos.x = new_pos.x % planet_size
	new_pos.y = clamp(pos.y, 0, 1)
	return new_pos
