extends Node2D
class_name VirtualPlanet

@export var planet: Planet

@export var face_size: float = 90.0

@export var rotation_speed: float = 1.8
var target_rotation: float = 0.0

func _ready() -> void:
	planet.gen_tiles()
	draw_planet_layers()
	

func _process(delta: float) -> void:
	handle_rotation_input(delta)
	rotation = lerp_angle(rotation, target_rotation, 5 * delta)
	
	
func cart_to_polar(obj_pos: Vector2):
	return Utils.cart_to_polar(position, obj_pos)

func polar_to_cart(polar: Utils.polarCoord):
	return Utils.polar_to_cart(position, polar)

func draw_planet_layers() -> void:
	var inner_radius: float = (planet.size * face_size)/ TAU
	var radian_per_face: float = TAU / planet.size
	
	var vertex = PackedVector2Array()
	var polar = Utils.polarCoord.new()
	
	var inner_layer: Polygon2D = $Inner_Layer
	polar.py = inner_radius
	
	for v in range(planet.size):
		polar.px = radian_per_face * v
		vertex.append(polar_to_cart(polar))
	inner_layer.polygon = vertex
	
	var outer_layer: Polygon2D = $Outer_Layer
	vertex.clear()
	polar.py += 100
	
	for v in range(planet.size):
		polar.px = radian_per_face * v
		vertex.append(polar_to_cart(polar))
	outer_layer.polygon = vertex
	return
	
func handle_rotation_input(delta: float):
	var input_dir = Input.get_axis("Rotate_left", "Rotate_right")
	
	if input_dir != 0:
		# Somamos o input ao nosso alvo de rotação
		target_rotation -= input_dir * rotation_speed * delta
