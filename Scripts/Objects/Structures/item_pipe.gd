extends Structure
class_name Pipe

var locked_item: Item = null

func can_receive_item(item):
	return locked_item == item

func _get_ticked():
	if locked_item != null:
		try_output_items(locked_item)
