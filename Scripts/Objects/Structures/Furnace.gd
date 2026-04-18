extends RecipeStructure
class_name Furnace

func _get_ticked():
	if locked_recipe == null:
		
		return
	
	progress += 1
	if progress >= locked_recipe.craft_time:
		progress = 0
		
		if can_craft():
			
			var inv: Inventory = get_inventory()
			for input in locked_recipe.inputs.keys():
				inv.remove_item(input, locked_recipe.inputs[input])
			for output in locked_recipe.outputs.keys():
				if locked_recipe.outputs[output] <= inv.max_contents - inv.contents[output]:
					inv.add_item(output, locked_recipe.outputs[output])
			
	
	
	for product in locked_recipe.outputs.keys():
		try_output_items(product)
		
		
