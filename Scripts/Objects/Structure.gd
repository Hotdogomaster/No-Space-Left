extends Node2D
class_name Structure

var planet: Planet
var struct_position: Vector2i #Vetor de posição dentro de acesso para um array

@export var Sname: String = "Structure"

@export var item_transfer_rate: int = 1
@export var accepts_input: bool = true

@export var output_offset: Array[Vector2i] #até 2 outputs
@export var max_outputs: int = 1
@export var min_output_range: int = 1
@export var max_output_range: int = 1

@export var modules: Array[Module]

func get_output_position(index: int = 0) -> Vector2i:
	return struct_position + output_offset[index]

func _get_ticked():
	print("ainnn para main! Eu sou o " + name)
	
func push_item(offset: Vector2i, item:Item):
	var target_pos = struct_position + offset
	
	if target_pos.y > 1 or target_pos.y < 0:
		return false
	
	target_pos = planet.normalize_pos(target_pos)
	
	var target_structure: Structure = planet.get_structure(target_pos)
	
	if target_structure == null:
		return false
	
	if !target_structure.accepts_input:
		return false
	
	if target_structure.has_method("can_receive_item"): #função de controle do cano
		if target_structure.locked_item == null:
			target_structure.locked_item = item
		if !target_structure.can_receive_item(item):
			return false
	
	var target_inventory : Inventory = target_structure.get_inventory()
	
	if target_inventory == null:
		return false
	
	if not target_inventory.can_receive(item, item_transfer_rate):
		return false
	
	if !target_inventory.contents.has(item):
		target_inventory.contents[item] = 0
	
	var new_amount = calculate_amount(target_inventory, item)
	target_inventory.add_item(item, new_amount)
	print(name, " empurrei ", new_amount ," item para ", target_structure.name, "!")
	get_inventory().remove_item(item, new_amount)
	return true

func get_inventory() -> Inventory:
	for m in modules:
		if m is Inventory:
			return m
	return null
	
func calculate_amount(target: Inventory, item: Item) -> int:
	var amount_remeaning = target.max_contents - target.contents[item]
	var amount_avalible = get_inventory().contents[item]
	
	
	return min(item_transfer_rate, amount_avalible, amount_remeaning)
	
func recalculate_priority():
	var priority = {
		Vector2i(1, 0): 0,   # RIGHT
		Vector2i(0, 1): 1,   # UP
		Vector2i(-1, 0): 2,  # LEFT
		Vector2i(0, -1): 3   # DOWN
	}

	output_offset.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		return priority.get(a, 999) < priority.get(b, 999)
	)
	
	
