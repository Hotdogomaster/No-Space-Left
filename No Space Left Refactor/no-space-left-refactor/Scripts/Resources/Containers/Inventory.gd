extends BContainer
class_name ItemContainer

var contents: Dictionary
@export var max_item: int = 10
@export var max_contents: int = 20
@export var item_transfer_rate: int = 2
@export var can_receive: bool = true

func calc_amount_remain(item: Item):
	var total_items: int = 0
	for i in contents.keys():
		total_items += contents[i]
	
	return min(max_item - contents[item], max_contents - total_items)

func calc_min_amount(amount: int, item: Item, target_item_c: ItemContainer):
	return min(contents[item], amount, target_item_c.calc_amount_remain(item))

func add_item(item: Item, amount: int):
	if !contents.has(item):
		contents[item] = 0
	
	contents[item] += min(amount, calc_amount_remain(item))


func remove_item(item: Item, amount: int):
	if !contents.has(item):
		return false
	
	contents[item] -= calc_min_amount(amount, item, self)
	contents[item] = max(contents[item], 0)
	
	return true

func transfer_to(target: ItemContainer, item: Item):
	if !contents.has(item) or !target.can_receive:
		return
	
	var amount = calc_min_amount(item_transfer_rate, item, target)
	
	if amount > 0:
		self.remove_item(item, amount)
		target.add_item(item, amount)
