extends Node

var can_tick: bool = true

var tick_frequency: float = 1.0

var accumulator: float

signal tick()

func _process(delta: float) -> void:
	
	if can_tick:
		accumulator += delta
		
		if accumulator >= 1/tick_frequency:
			accumulator = 0.0
			tick.emit()
			print("Tick.")
