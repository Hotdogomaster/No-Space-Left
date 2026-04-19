extends Node2D
class_name VirtualPlanet

const face_size = 87

@export var planet: Planet
@export var inner_crust: Polygon2D
@export var outer_crust: Polygon2D
@export var highlight: Line2D

# Configurações de Rotação
@export var rotation_speed: float = 1.5  # Força do giro por clique/tecla
@export var lerp_speed: float = 5.0    # Suavidade (quanto menor, mais "pesado" o planeta parece)

var target_rotation: float = 0.0

func _ready() -> void:
	
	planet.generate_tiles()
	planet.array_update.connect(_on_array_changed)
	draw_crust()
	target_rotation = rotation
	

func _process(delta: float) -> void:
	# 1. Captura o input e define o alvo
	handle_rotation_input(delta)
	
	# 2. Suaviza a rotação atual usando lerp_angle
	# O lerp_angle garante que o giro seja feito pelo caminho mais curto
	rotation = lerp_angle(rotation, target_rotation, lerp_speed * delta)

func _on_array_changed(pos: Vector2i):
	if planet.get_structure(pos) == null:
		render_structure(pos)
		
	else:
		render_structure(pos)
		
	pass


func handle_rotation_input(delta: float):
	var input_dir = Input.get_axis("Rotate_left", "Rotate_right")
	
	if input_dir != 0:
		# Somamos o input ao nosso alvo de rotação
		target_rotation -= input_dir * rotation_speed * delta

func draw_crust():
	var points = PackedVector2Array()
	var angle_division = deg_to_rad(360.0 / planet.planet_size)
	var radius = (planet.planet_size * face_size)/ TAU
	
	
	for i in planet.planet_size:
		var x = radius * cos(angle_division * i)
		var y = radius * sin(angle_division * i)
		points.append(Vector2(x, y))
		
	inner_crust.polygon = points
	
	for j in planet.planet_size:
		points[j] = points[j] / radius * (radius+100)
	outer_crust.polygon = points

func render_structure(pos: Vector2i):
	if planet.get_structure(pos) == null:
		for child in get_children():
			if child is Structure:
				if child.struct_position == pos:
					child.queue_free()
					return 
		return
	var structure = planet.get_structure(pos)
	var angle_division = deg_to_rad(360.0 / planet.planet_size)
	var radius = (planet.planet_size * face_size)/ TAU
	structure.position.x = (radius + (pos.y * 100)) * cos(angle_division * pos.x) 
	structure.position.y = (radius + (pos.y * 100)) * sin(angle_division * pos.x)
	structure.rotation = angle_division * (pos.x + 0.5) + PI / 2
	var sprite: Node2D = structure.get_child(0)
	var Lface_size = 2 * PI * (radius + (pos.y * 100)) / planet.planet_size
	sprite.position.x = Lface_size / 2
	add_child(structure)
	
func render_highlight(pos: Vector2i, color: Color = Color(70.0, 116.0, 255.0, 255.0)):
	var angle_division = deg_to_rad(360.0 / planet.planet_size)
	var radius = (planet.planet_size * face_size)/ TAU
	var outer_size = face_size * radius / (radius+100)
	highlight.default_color = color/255.0
	highlight.points[0].x = ((face_size -outer_size ) * pos.y) + face_size
	highlight.position.x = (4 +radius + (pos.y * 100)) * cos((angle_division * pos.x) + rotation) + position.x
	highlight.position.y = (4+ radius + (pos.y * 100)) * sin((angle_division * pos.x) + rotation) + position.y
	highlight.rotation = (angle_division * (pos.x + 0.5) + PI / 2) + rotation
