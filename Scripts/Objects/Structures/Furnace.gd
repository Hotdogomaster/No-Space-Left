extends Structure
class_name Furnace

@export var recipes: Array[Recipe]

var locked_recipe: Recipe = null

var progress: int

func verify_recipe():
	var inv: Inventory = get_inventory()
	var items = inv.contents.keys()
	for recipe: Recipe in recipes:
		var matchs: int = recipe.inputs.size()
		for item in items:
			if recipe.inputs.has(item):
				matchs -= 1
		if matchs == 0:
			locked_recipe = recipe
			print("Agora eu ", name, " tenho o recipe ", locked_recipe, "!")
			for item in locked_recipe.outputs.keys():
				inv.contents[item] = 0
			break

func can_craft() -> bool:
	var input_items = locked_recipe.inputs.keys()
	var matchs = input_items.size()
	for input: Item in input_items:
		if get_inventory().contents[input] >= locked_recipe.inputs[input]:
			matchs -= 1
	if matchs == 0:
		matchs = locked_recipe.outputs.keys().size()
		for output: Item in locked_recipe.outputs.keys():
			if locked_recipe.outputs[output] <= get_inventory().max_contents - get_inventory().contents[output]:
				matchs -= 1
		if matchs == 0:
			return true
	return false

func _get_ticked():
	if locked_recipe == null:
		print("Eu ", name, " não tenho recipe ainda.")
		verify_recipe()
		return
	print("Eu ", name, " tenho esses items: ", get_inventory().contents, "!")
	progress += 1
	if progress >= locked_recipe.craft_time:
		progress = 0
		print("Eu ", name, " vou tentar craftar!")
		if can_craft():
			print("Estou craftando!")
			var inv: Inventory = get_inventory()
			for input in locked_recipe.inputs.keys():
				inv.remove_item(input, locked_recipe.inputs[input])
			for output in locked_recipe.outputs.keys():
				if locked_recipe.outputs[output] <= inv.max_contents - inv.contents[output]:
					inv.add_item(output, locked_recipe.outputs[output])
			print("Eu terminei de Craftar e tenho isso: ", inv.contents)
	
	for output in output_offset:
		for product in locked_recipe.outputs.keys():
			push_item(output, product)
			
			
