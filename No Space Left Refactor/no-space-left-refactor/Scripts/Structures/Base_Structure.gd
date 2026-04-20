extends Node2D
class_name Structure

@export var struct_name: String = "Hotdog_Machine"

@export_category("Output Management")
@export var max_outputs: int = 1
@export var output_min_range: int = 1
@export var output_max_range: int = 1
var outputs: Array[Vector2i]

var grid_pos: Vector2i

var planet: Planet

@export var item_container: ItemContainer
#@export var fluid_container:
#@export var gas_container: ???

func _init():
	GameManager.tick.connect(on_tick)

func on_tick():
	pass

func get_tile_from_output(index: int):
	var output_pos = planet.normalize_pos(outputs[index] + grid_pos)
	return planet.tile_grid[output_pos.x][output_pos.y]

func recalculate_priority():
	var priority = {
		Vector2i(1, 0): 0,   # RIGHT
		Vector2i(0, 1): 1,   # UP
		Vector2i(-1, 0): 2,  # LEFT
		Vector2i(0, -1): 3   # DOWN
	}

	outputs.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		return priority.get(a, 999) < priority.get(b, 999)
	)

func check_offset(pos: Vector2i):
	return true
