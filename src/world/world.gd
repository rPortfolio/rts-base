extends Node3D


const UNIT_SCENE: PackedScene = preload("res://src/world/unit/unit.tscn")
@onready var camera: Camera3D = %WorldCamera


func _ready() -> void:
	Events.selection_made.connect(_on_selection_made)


func _unhandled_input(event: InputEvent) -> void:
	if camera.is_cursor_on_screen():
		if event.is_action_pressed("left_click"):
			add_unit()
		elif event.is_action_pressed("right_click"):
			call_units()


func add_unit() -> void:
	var new_unit: Unit = UNIT_SCENE.instantiate()
	new_unit.position = camera.get_cursor_position()
	new_unit.target_position = camera.get_cursor_position()
	%Units.add_child(new_unit)


func call_units() -> void:
	for child: Unit in %Units.get_children():
		child.target_position = camera.get_cursor_position()


func kill_units() -> void:
	for child: Unit in %Units.get_children():
		child.queue_free()


func load_units(units: Array[SavedUnit]) -> void:
	for saved_unit in units:
		var new_unit: Unit = UNIT_SCENE.instantiate()
		new_unit.position = saved_unit.position
		%Units.add_child(new_unit)
		new_unit.fsm.starting_state = saved_unit.state_name
		new_unit.target_position = saved_unit.target_position


func get_units() -> Array[SavedUnit]:
	var units: Array[SavedUnit] = []
	for child: Unit in %Units.get_children():
		units.append(child.get_saved_unit())
	return units


func _on_selection_made(selection_rect: Rect2) -> void:
	for unit: Unit in %Units.get_children():
		var unit_pos := camera.unproject_position(unit.global_position)
		var is_in_box_hor := unit_pos.x > selection_rect.position.x and unit_pos.x < selection_rect.position.x + selection_rect.size.x
		var is_in_box_vert := unit_pos.y > selection_rect.position.y and unit_pos.y < selection_rect.position.y + selection_rect.size.y
		if is_in_box_hor and is_in_box_vert:
			unit.queue_free()
