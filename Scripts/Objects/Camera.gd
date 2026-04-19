extends Camera2D


# Configurações de Zoom
@export var zoom_speed: float = 0.5  # O quão "forte" é cada clique
@export var lerp_speed: float = 5.0 # O quão suave é a transição
@export var min_zoom: float = 0.4
@export var max_zoom: float = 1.2

@export var planet: VirtualPlanet

# Variável para armazenar o zoom que desejamos alcançar
var target_zoom: Vector2

var tween: Tween

var final_pos: float
var early_pos: float

func _ready() -> void:
	
	target_zoom = zoom
	var radius = (planet.planet.planet_size * planet.face_size)/ TAU
	
	final_pos = radius
	early_pos = planet.position.y
	position.y = early_pos

func _process(delta: float) -> void:
	handle_input(delta)
	run_lerp(delta)
	

func handle_input(delta):
	# Input para aumentar o zoom (aproximar)
	var zoomY: float
	if Input.is_action_just_pressed("Zoom_in"):
		set_zoom_target(target_zoom.x + zoom_speed)
		#run_tween(delta)
		
		
	# Input para diminuir o zoom (afastar)
	if Input.is_action_just_pressed("Zoom_out"):
		set_zoom_target(target_zoom.x - zoom_speed)
		
		

func set_zoom_target(value: float):
	# Clamp garante que o valor fique entre o mínimo e o máximo
	var new_zoom = clamp(value, min_zoom, max_zoom)
	target_zoom = Vector2(new_zoom, new_zoom)

func run_lerp(delta):
	# 1. Atualiza o zoom primeiro
	zoom = lerp(zoom, target_zoom, lerp_speed * delta)
	
	# 2. Definimos os dois destinos possíveis:
	var centro_do_planeta = early_pos # Geralmente a posição do VirtualPlanet
	
	var half_viewport = 320.0
	# Posição calculada para manter a borda em -300
	var posicao_superficie = (early_pos - final_pos - 300) + (half_viewport / zoom.x)
	
	# 3. Criamos um "Peso" (0.0 a 1.0) baseado no zoom atual
	# Quando zoom é 0.4 (min), peso é 0.0 -> Foca no Centro
	# Quando zoom aumenta, peso vai para 1.0 -> Foca na Superfície
	var peso = remap(zoom.x, min_zoom, max_zoom, 0.0, 1.0)
	
	# Suavizamos o peso com um ease para a transição não ser linear
	# Um valor de 2.0 faz com que ele fique no centro por mais tempo antes de subir
	var peso_suave = ease(peso, 0.5) 
	
	# 4. A posição final é uma mistura das duas
	var target_y = lerp(centro_do_planeta, posicao_superficie, peso_suave)
	
	# 5. Aplica o movimento
	position.y = lerp(position.y, target_y, lerp_speed * delta)
	
