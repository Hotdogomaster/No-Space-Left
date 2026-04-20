extends Structure
class_name Catapult

var cooldown: int = 0

var locked_item: Item = null

@export var time_to_shot: int = 3

func check_offset(pos: Vector2i):
	if planet.get_structure(pos) == null:
		if !output_offset.is_empty():
			output_offset.clear()
		return false
	if planet.get_structure(pos).Sname != "Receiver":
		if !output_offset.is_empty():
			output_offset.clear()
		return false
	return true

func can_receive_item(item):
	return locked_item == item

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if output_offset.is_empty():
		return
	cooldown = clamp(cooldown+1, 0, time_to_shot)
	if locked_item != null and get_inventory().contents[locked_item] == get_inventory().max_contents:
		if cooldown == time_to_shot:
			cooldown = 0
			try_output_items(locked_item)
	
