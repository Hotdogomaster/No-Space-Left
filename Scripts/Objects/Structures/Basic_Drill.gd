extends Structure
class_name Drill

var item_to_mine: Item
@export var mine_time:int = 1
var mine_amount:int = 1
var progress: int = 0

func _ready() -> void:
	
	item_to_mine = planet.get_tile(struct_position).ore
	mine_amount = round(float(planet.get_tile(struct_position).ore_rich)*5.0/100.0)
	


func _get_ticked():
	if item_to_mine == null:
		return
	
	progress += 1
	var inv: Inventory = get_inventory()
	if progress >= mine_time: 
		
		if inv.can_receive(item_to_mine, mine_amount, true):
			inv.add_item(item_to_mine, mine_amount)
		
		progress = 0
	
	try_output_items(item_to_mine)
		
		
