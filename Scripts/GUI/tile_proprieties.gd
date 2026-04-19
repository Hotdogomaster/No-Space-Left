extends Panel

var selec_tile = null

@export var ore_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selec_tile != null:
		animate_appear(false)
		set_labels()
	else:
		animate_appear()
	

func set_labels():
	if selec_tile.ore == null:
		ore_label.text = "No ores in this tile."
		return
	ore_label.text = str(selec_tile.ore.name) + ": " + str(selec_tile.ore_rich)

func animate_horizontal(x, method: bool = true):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	if method:
		tween.set_ease(Tween.EASE_OUT)
	else:
		tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", Vector2(x, 0), 0.6)
	
func animate_appear(method: bool = true):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	if method:
		
		tween.tween_property(self, "scale", Vector2.ZERO, 0.6)
		if tween.is_running() and tween.get_total_elapsed_time() >= 0.1:
			print("sla kkkadksdads")
			visible = false
	else:
		visible = true
		tween.tween_property(self, "scale", Vector2.ONE, 0.6)

func _on_main_getted_tile(tile: Variant) -> void:
	selec_tile = tile
	



func _on_main_get_config(structure: Structure) -> void:
	if selec_tile != null:
		
		if structure != null:
			animate_horizontal(205)
		else:
			animate_horizontal(0, false)
	else:
		
		animate_horizontal(0, false)
