extends Panel

@export var name_label: Label
@export var inventory_label: Label
@export var offset_label: Label
@export var offset_button: Button

var selec_struct: Structure = null

func _process(_delta: float) -> void:
	if selec_struct != null:
		set_labels()
	
	pass
	

func _on_main_get_config(structure) -> void:
	selec_struct = structure
	if structure == null:
		
		animate(true)

func set_labels():
	if selec_struct == null:
		name_label.text = ""
		inventory_label.text = ""
		offset_label.text = ""
		offset_button.disabled = true
		offset_button.visible = false
		animate(true)
		
		
		return
	
	animate(false)
	name_label.text = selec_struct.Sname
	set_inventory_label(selec_struct)
	set_offset_label(selec_struct)
	offset_button.disabled = false
	offset_button.visible = true
	
	

func set_offset_label(struct: Structure):
	var offsets = struct.output_offset
	
	match offsets.size():
		0:
			offset_label.text = ""
		1:
			offset_label.text = "output0: " + str(offsets[0])
		2:
			offset_label.text = "output0: " + str(offsets[0]) + ", output1: " + str(offsets[1])

func set_inventory_label(struct: Structure):
	var contents: Dictionary = struct.get_inventory().contents
	var keys: Array = contents.keys()
	inventory_label.text = ""
	for key:Item in keys:
		inventory_label.text += key.name + ": " + str(contents[key]) + "\n"
		

func animate(out: bool):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	if out:
		tween.tween_property(self, "scale", Vector2.ZERO, 0.6)
		if tween.get_total_elapsed_time() >= 0.2:
			visible = false
	else:
		visible = true
		tween.tween_property(self, "scale", Vector2.ONE, 0.6)
