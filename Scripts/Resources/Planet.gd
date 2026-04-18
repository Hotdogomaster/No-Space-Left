extends Resource
class_name Planet

signal array_update(pos:Vector2i)

class tile:
	var structure: Structure = null
	var can_construct: bool = true
	var ore: Item
	var ore_rich: int
	var ore_value: float

@export var ores_available: Array[Item] = [] # Lista de itens (Minérios)
@export var ore_distribution: Array[float] = [] # Porcentagens (ex: [50, 30, 20]) - Vazio, Ferro, Cobre
@export var global_richness: float = 1

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
	generate_ores()

func generate_ores():
	var noise_dist = FastNoiseLite.new()
	var noise_rich = FastNoiseLite.new()
	
	noise_rich.frequency = 0.6
	noise_rich.fractal_octaves = 2
	
	noise_dist.frequency = 0.54
	noise_dist.fractal_octaves = 1
	
	for y in range(2):
		for x in planet_size:
			var current_tile: tile = get_tile(Vector2i(x, y))
			var angle = (float(x) / planet_size) * TAU
			var nx = cos(angle)
			var ny = sin(angle)
			#Geração de rich patches
			var normalized_value1 = (noise_rich.get_noise_3d(nx, ny, y) + 1.0) / 2
			var coef_rich = global_richness + randf_range(-0.15 * global_richness, 0.05 * global_richness)
			current_tile.ore_rich = clamp(normalized_value1 * coef_rich , 0, 1) * 100
			#Geração de ores
			var raw_noise = (noise_dist.get_noise_3d(nx, ny, y) + 1.0) / 2
			var normalized_value0 =  remap(raw_noise, 0.2, 0.8, 0, 1)
			var coef = randf_range(0.95, 1.05)
			var ore_value = clamp(normalized_value0 * coef, 0, 1)
			var threshold: float = 0
			var index: int = -1
			for chance in range(ore_distribution.size()):
					
					if ore_value >= ore_distribution[chance]/100 and threshold < ore_distribution[chance]/100:
						threshold = ore_distribution[chance]/100
						index = chance
			if index == -1:
				current_tile.ore = null
			else:
				current_tile.ore = ores_available[index]
			current_tile.ore_value = ore_value

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
	if new_pos.x < 0:
		new_pos.x = planet_size - 1 + new_pos.x
	new_pos.y = clamp(pos.y, 0, 1)
	return new_pos
