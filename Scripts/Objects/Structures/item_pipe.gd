extends Structure
class_name Pipe

var locked_item: Item = null

func can_receive_item(item):
	return locked_item == item

func _get_ticked():
	print(name, " inventario: ", get_inventory().contents)
	#print(name + " tenho " + str(get_inventory().contents[locked_item]))
	if locked_item != null:
		for output in output_offset:
			push_item(output, locked_item)
