extends Module
class_name Inventory

var contents: Dictionary = {}
@export var max_contents: int = 10

@export var accepts_inputs: bool = true

func can_receive(item: Item, amount:int = 1,  its_self:bool = false):
	if !contents.has(item):
		return true
		
	if its_self:
		return contents[item] < max_contents
	
	if !accepts_inputs:
		return false
	
	return contents[item] < max_contents

func add_item(item: Item, amount:int = 1):
	if !contents.has(item):
		contents[item] = 0
	
	contents[item] += amount
	contents[item] = min(contents[item], max_contents)
	

func remove_item(item: Item, amount:int = 1):
	if !contents.has(item):
		return false
	var new_value = contents[item] - amount
	contents[item] = max(new_value, 0)
