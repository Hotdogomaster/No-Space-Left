extends Camera2D


# Configurações de Zoom
@export var zoom_speed: float = 0.5  # O quão "forte" é cada clique
@export var lerp_speed: float = 10.0 # O quão suave é a transição
@export var min_zoom: float = 0.8
@export var max_zoom: float = 3.0

# Variável para armazenar o zoom que desejamos alcançar
var target_zoom: Vector2

func _ready() -> void:
	target_zoom = zoom

func _process(delta: float) -> void:
	handle_input()
	
	# O LERP acontece aqui:
	# Ele move o zoom atual em direção ao target_zoom suavemente
	zoom = zoom.lerp(target_zoom, lerp_speed * delta)

func handle_input():
	# Input para aumentar o zoom (aproximar)
	var zoomY: float
	if Input.is_action_just_pressed("Zoom_in"):
		set_zoom_target(target_zoom.x + zoom_speed)
		
		
		
	# Input para diminuir o zoom (afastar)
	if Input.is_action_just_pressed("Zoom_out"):
		set_zoom_target(target_zoom.x - zoom_speed)
		
		

func set_zoom_target(value: float):
	# Clamp garante que o valor fique entre o mínimo e o máximo
	var new_zoom = clamp(value, min_zoom, max_zoom)
	target_zoom = Vector2(new_zoom, new_zoom)
