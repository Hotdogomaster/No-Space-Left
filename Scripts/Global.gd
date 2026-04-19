extends Node

var can_tick: bool = true

var tick_frequency = 2.0

var accumulator: float

var structures: Array[Structure]

func _process(delta: float) -> void:
	accumulator += delta
	if accumulator >= 1/tick_frequency and can_tick:
		accumulator = 0.0
		print("Ticked!")
		for s in structures:
			if s != null:
				print("Tickando: ", s)
				s._get_ticked()
			
			
