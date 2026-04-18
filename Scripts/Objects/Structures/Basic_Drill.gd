extends Structure
class_name Drill

@export var item_to_mine: Item
@export var mine_time:int = 1
@export var mine_amount:int = 1
var progress: int = 0

func _ready() -> void:
	#get_inventory().add_item(item_to_mine, 1)
	pass

func _get_ticked():
	progress += 1
	var inv: Inventory = get_inventory()
	if progress >= mine_time: 
		
		if inv.can_receive(item_to_mine, mine_amount, true):
			inv.add_item(item_to_mine, mine_amount)
			print("minerei!")
			print(inv.contents)
		
		progress = 0
	
	for output: Vector2i in output_offset:
		push_item(output, item_to_mine)
		
		
