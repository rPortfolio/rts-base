extends Node3D


const UNIT_SCENE: PackedScene = preload("res://src/world/unit/unit.tscn")
var selected_units: Array[Unit] = []
@onready var world_camera: Node3D = %WorldCamera


func _ready() -> void:
	Events.selection_made.connect(_on_selection_made)


func _unhandled_input(event: InputEvent) -> void:
	if world_camera.is_cursor_on_screen() and not Input.is_action_just_pressed("mid_click"):
		if event.is_action_pressed("left_click"):
			add_unit()
		elif event.is_action_pressed("right_click"):
			call_units()


func add_unit() -> void:
	var new_unit: Unit = UNIT_SCENE.instantiate()
	new_unit.position = world_camera.get_cursor_position()
	new_unit.target_position = world_camera.get_cursor_position()
	%Units.add_child(new_unit)


func call_units() -> void:
	for child: Unit in selected_units:
		child.target_position = world_camera.get_cursor_position()


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


func is_unit_selected(selection_rect: Rect2, unit: Unit) -> bool:
	var unit_pos: Vector2 = world_camera.camera.unproject_position(unit.global_position)
	return selection_rect.has_point(unit_pos)


func _on_selection_made(selection_rect: Rect2) -> void:
	while not selected_units.is_empty():
		selected_units.pop_front().unselect()
	for unit: Unit in %Units.get_children():
		if is_unit_selected(selection_rect, unit):
			selected_units.append(unit)
			unit.select()
