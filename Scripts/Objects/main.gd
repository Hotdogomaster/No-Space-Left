extends Node

@export var planet: VirtualPlanet

var structure_construction: Array = ["res://Scenes/Structures/drill.tscn", "res://Scenes/Structures/furnace.tscn", "res://Scenes/Structures/pipe.tscn"]
var structure_selected: PackedScene

signal get_config(structure: Structure)
signal mode_changed(mode: String)
signal construction_selected(structure_name: String)
signal getted_tile(tile)

var modes: Array[String] = ["NORMAL", "BUILD_MODE", "CONFIG_MODE"] 
var selected_mode: String = "NORMAL"

var by_button: bool = false

var structure_config: Structure = null
var output_index: int = 0

var last_structure: Structure = null

var hlight_color: Color

var copied_structure: Dictionary = {
	"name" = "",
	"outputs" = []
}

func _ready() -> void:
	structure_construction.push_front(null)

func _process(delta: float) -> void:
	set_highlight()
	pass

func get_tile_from_mouse() -> Vector2i:
	var mouse_pos = planet.get_global_mouse_position()
	var planet_pos = planet.global_position
	
	# vetor do planeta até o mouse
	var dir = mouse_pos - planet_pos
	
	# ângulo em radianos (-PI a PI)
	var angle = planet.get_angle_to(mouse_pos)
	
	# converter pra 0 → TAU
	if angle < 0:
		angle += TAU
	
	var angle_division = TAU / planet.planet.planet_size
	
	# índice do tile
	var x = int(angle / angle_division)
	var radius = (planet.planet.planet_size * planet.face_size)/ TAU
	if planet.position.distance_to(mouse_pos) >= radius - 20:
		if planet.position.distance_to(mouse_pos) >= radius + 90 and radius + 190 > planet.position.distance_to(mouse_pos):
			return Vector2i(x, 1)
		if planet.position.distance_to(mouse_pos) < radius + 90:
			return Vector2i(x, 0)
	return Vector2i(0, 5)
	

func _input(event: InputEvent) -> void:
	get_key(event)
	click()
	

func try_get_config():
	if get_tile_from_mouse().y != 5:
		get_config.emit(planet.planet.get_structure(get_tile_from_mouse()))
	else:
		get_config.emit(null)

func can_construct():
	if structure_selected == null:
		
		return false
	if planet.planet.get_structure(get_tile_from_mouse()) != null:
		last_structure = planet.planet.get_structure(get_tile_from_mouse())
		return false
	
	return true

func try_construct():
	if get_tile_from_mouse().y != 5:
			
			if last_structure != null:
				try_output(last_structure)
				output_index = 0
			
			if !can_construct():
				return
			
			planet.planet.add_structure(structure_selected, get_tile_from_mouse())
			last_structure = planet.planet.get_structure(get_tile_from_mouse())
			

func try_removing():
	if get_tile_from_mouse().y != 5:
			
			planet.planet.remove_structure(get_tile_from_mouse())

func try_output(struct: Structure):
	if get_tile_from_mouse().y != 5:
		
		
		var diff_x = get_tile_from_mouse().x - struct.struct_position.x
		var diff_y = get_tile_from_mouse().y - struct.struct_position.y
		
		if abs(diff_x) > planet.planet.planet_size / 2.0:
			diff_x -= planet.planet.planet_size * sign(diff_x)
			
		var offset: Vector2i = Vector2i(diff_x, diff_y)
		
		var offset_range = absi(offset.x) + absi(offset.y)
		
		if offset_range < struct.min_output_range:
			return
		
		if offset_range > struct.max_output_range:
			return
		
		if struct.max_outputs == 2:
			
			struct.output_offset.resize(output_index+1)
			struct.output_offset[output_index] = offset
			if output_index == 1:
				output_index = 0
				return
			output_index = 1
			
		if struct.max_outputs == 1:
			
			struct.output_offset.resize(1)
			struct.output_offset[output_index] = offset
			

func click():
	if Input.is_action_pressed("Left_Click"):
		if selected_mode == "BUILD_MODE":
			
			try_construct()
			
	if Input.is_action_pressed("Right_Click"):
		if selected_mode == "BUILD_MODE":
			try_removing()
	if Input.is_action_just_pressed("Left_Click"):
		match selected_mode:
			"NORMAL":
				if !by_button:
					try_get_config()
			"CONFIG_MODE":
				try_output(structure_config)
	if Input.is_action_just_released("Left_Click"):
		if selected_mode == "BUILD_MODE":
			
			last_structure = null
			
func change_mode(mode: String):
	
	if selected_mode == mode:
		selected_mode = modes[0]
		mode_changed.emit(modes[0])
		if selected_mode == modes[0]:
			select_structure(0)
			get_config.emit(null)
		return
	mode_changed.emit(mode)
	selected_mode = mode

	if selected_mode == modes[0]:
		get_config.emit(null)
		select_structure(0)




func get_key(event: InputEvent):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				select_structure(1)
			KEY_2:
				select_structure(2)
			KEY_3:
				select_structure(3)
			KEY_4:
				select_structure(4)
			KEY_Q:
				change_mode(modes[1])
			KEY_ESCAPE:
				change_mode(modes[0])
	
		

func select_structure(index):
	
	if selected_mode != modes[1]:
		structure_selected = structure_construction[0]
		construction_selected.emit("")
		return
	
	structure_selected = load(structure_construction[index])
	
	if structure_selected == null:
		
		construction_selected.emit("")
		return
	var structure = structure_selected.instantiate()
	construction_selected.emit(structure.name)
	structure = null


func _on_button_pressed() -> void:
	change_mode(modes[2])
	pass # Replace with function body.


func _on_button_mouse_entered() -> void:
	by_button = true


func _on_button_mouse_exited() -> void:
	by_button = false


func _on_get_config(structure:Structure) -> void:
	
	structure_config = structure
	output_index = 0
	
func set_highlight():
	if get_tile_from_mouse().y != 5:
		if selected_mode == "BUILD_MODE":
			if can_construct() and !Input.is_action_pressed("Right_Click"):
				hlight_color = Color(116, 222, 31, 255)
			else:
				hlight_color = Color(255, 44, 36, 255)
		else:
			hlight_color = Color(70.0, 116.0, 255.0, 255.0)
		getted_tile.emit(planet.planet.get_tile(get_tile_from_mouse())) 
		planet.render_highlight(get_tile_from_mouse(), hlight_color)
		planet.highlight.visible = true
	else:
		getted_tile.emit(null)
		planet.highlight.visible = false
