extends Structure
class_name RecipeStructure

@export var recipes: Array[Recipe]

var locked_recipe: Recipe = null

var progress: int

func _ready() -> void:
	get_inventory().new_item_added.connect(on_item_added)

func on_item_added():
	print("bolacha")
	verify_recipe()

func verify_recipe():
	if locked_recipe != null:
		return
	
	var inv: Inventory = get_inventory()
	var items = inv.contents.keys()
	for recipe: Recipe in recipes:
		var matchs: int = recipe.inputs.size()
		for item in items:
			if recipe.inputs.has(item):
				matchs -= 1
		if matchs == 0:
			locked_recipe = recipe
			
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
