extends Node2D
class_name VirtualPlanet

const base_size = 500

@export var planet: Planet
@export var inner_crust: Polygon2D
@export var outer_crust: Polygon2D

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
		print("não existe mais. ou nunca existiu...")
	else:
		render_structure(pos)
		print("foi adicionado o ", planet.get_tile(pos).structure.name)
	pass


func handle_rotation_input(delta: float):
	var input_dir = Input.get_axis("Rotate_left", "Rotate_right")
	
	if input_dir != 0:
		# Somamos o input ao nosso alvo de rotação
		target_rotation -= input_dir * rotation_speed * delta

func draw_crust():
	var points = PackedVector2Array()
	var angle_division = deg_to_rad(360.0 / planet.planet_size)
	
	for i in planet.planet_size:
		var x = base_size * cos(angle_division * i)
		var y = base_size * sin(angle_division * i)
		points.append(Vector2(x, y))
		
	inner_crust.polygon = points
	
	for j in planet.planet_size:
		points[j] = points[j] / base_size * (base_size+100)
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
	structure.position.x = (base_size + (pos.y * 100)) * cos(angle_division * pos.x) 
	structure.position.y = (base_size + (pos.y * 100)) * sin(angle_division * pos.x)
	structure.rotation = angle_division * (pos.x + 0.5) + PI / 2
	var sprite: Node2D = structure.get_child(0)
	var face_size = 2 * PI * (base_size + (pos.y * 100)) / planet.planet_size
	sprite.position.x = face_size / 2
	add_child(structure)
	
	
	
