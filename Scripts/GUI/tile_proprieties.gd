extends Panel

var selec_tile = null

@export var ore_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selec_tile != null:
		set_labels()
	pass


func _on_main_get_config(tile: Variant, structure) -> void:
	selec_tile = tile
	if selec_tile != null:
		visible = true
		if selec_tile.structure != null:
			position.x = 205
		else:
			position.x = 0
	else:
		visible = false
		position.x = 0
	
	pass # Replace with function body.

func set_labels():
	if selec_tile.ore == null:
		ore_label.text = "No ores in this tile."
		return
	ore_label.text = str(selec_tile.ore.name) + ": " + str(selec_tile.ore_rich)
