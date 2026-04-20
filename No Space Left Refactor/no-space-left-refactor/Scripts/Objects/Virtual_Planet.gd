extends Node2D
class_name VirtualPlanet

@export var planet: Planet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	planet.gen_tiles()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func cart_to_polar(obj_pos: Vector2):
	return Utils.cart_to_polar(position, obj_pos)

func polar_to_cart(polar: Utils.polarCoord):
	return Utils.polar_to_cart(position, polar)
