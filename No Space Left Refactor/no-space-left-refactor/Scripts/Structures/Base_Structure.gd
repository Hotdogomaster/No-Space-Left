extends Node2D
class_name Structure

@export var struct_name: String = "Hotdog_Machine"

@export_category("Output Management")
@export var max_outputs: int = 1
@export var output_min_range: int = 1
@export var output_max_range: int = 1

var grid_pos: Vector2i

@export var item_container: ItemContainer
#@export var fluid_container:
#@export var gas_container: ???
