extends RecipeStructure
class_name Press

func _get_ticked():
	if locked_recipe == null:
		
		return
	
	
	if can_craft():
		progress += 1
		
		if progress >= locked_recipe.craft_time:
			progress = 0
			
			var inv: Inventory = get_inventory()
			#remove os items do inventario conforme a recipe diz
			for input in locked_recipe.inputs.keys():
				inv.remove_item(input, locked_recipe.inputs[input])
			#adiciona os items no inventario
			for output in locked_recipe.outputs.keys():
				#verifica se o output está cheio
				if locked_recipe.outputs[output] <= inv.max_contents - inv.contents[output]:
					inv.add_item(output, locked_recipe.outputs[output])
			
	
	
	for product in locked_recipe.outputs.keys():
		try_output_items(product)
