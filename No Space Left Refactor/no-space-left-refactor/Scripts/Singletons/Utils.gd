extends Node

class polarCoord:
	var px: float #angulo
	var py: float #raio

func cart_to_polar(ref_pos: Vector2, obj_pos: Vector2) -> polarCoord:
	
	var polar = polarCoord.new()
	
	polar.py = obj_pos.distance_to(ref_pos)
	polar.px = atan2(obj_pos.y - ref_pos.y, obj_pos.x - ref_pos.x)
	
	return polar

func polar_to_cart(ref_pos: Vector2, polar: polarCoord) -> Vector2:
	
	var pos: Vector2
	
	pos.y = ref_pos.y + (polar.py * sin(polar.px))
	pos.x = ref_pos.x + (polar.py * cos(polar.px))
	
	return pos
	
