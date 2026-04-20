extends Node2D
class_name VirtualPlanet

@export var planet: Planet

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	planet.gen_tiles()
	print(planet.get_structure(Vector2i(0, 5)))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
