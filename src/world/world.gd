extends Node3D


const UNIT_SCENE: PackedScene = preload("res://src/world/unit/unit_types/test_unit.tscn")
var click_pos: Vector2
var is_dragging := false
var selected_units: Array[Unit] = []
@onready var world_camera: Node3D = %WorldCamera


func _process(_delta: float) -> void:
	if is_dragging:
		Events.area_selected.emit(get_selection_rect())


func _unhandled_input(event: InputEvent) -> void:
	if world_camera.is_cursor_on_screen() and not Input.is_action_just_pressed("mid_click"):
		if event.is_action_pressed("left_click"):
			add_unit()
		elif event.is_action_pressed("right_click"):
			call_units()
	if Input.is_action_just_pressed("mid_click"):
		click_pos = get_viewport().get_mouse_position()
		is_dragging = true 
	elif Input.is_action_just_released("mid_click"):
		select_units(get_selection_rect())
		is_dragging = false
		Events.area_selected.emit(Rect2()) ## Emit zero rect to hide selection rect


func get_selection_rect() -> Rect2:
	var rect := Rect2()
	var mouse_pos := get_viewport().get_mouse_position()
	rect.position.x = min(click_pos.x, mouse_pos.x)
	rect.position.y = min(click_pos.y, mouse_pos.y)
	
	rect.size.x = max(click_pos.x, mouse_pos.x) - rect.position.x
	rect.size.y = max(click_pos.y, mouse_pos.y) - rect.position.y
	return rect


func add_unit() -> void:
	var new_unit: Unit = UNIT_SCENE.instantiate()
	%Units.add_child(new_unit)
	new_unit.setup(world_camera.get_cursor_position(), world_camera.get_cursor_position())
	new_unit.target_position = world_camera.get_cursor_position()


func call_units() -> void:
	var n := selected_units.size()
	var target_positions := get_target_positions(world_camera.get_cursor_position(), n)
	for i in range(n):
		selected_units[i].target_position = target_positions[i]


## Square block of positions
func get_target_positions(target_position: Vector3, n: int) -> Array[Vector3]:
	var target_positions: Array[Vector3] = []
	
	const SEP := 1.5 # Separation in meters
	var lines := ceili(sqrt(n))
	var start_position := target_position
	start_position.x -= 0.25 * lines * SEP
	start_position.z -= 0.25 * lines * SEP
	
	for i in range(n):
		var new_target_position := start_position
		var current_line := floori(float(i) / lines)
		new_target_position.z += current_line * SEP
		var current_col := (i % lines)
		new_target_position.x += current_col * SEP
		target_positions.append(new_target_position)
	return target_positions


func kill_units() -> void:
	for child: Unit in %Units.get_children():
		child.queue_free()


func load_units(units: Array[SavedUnit]) -> void:
	for saved_unit in units:
		var new_unit: Unit = UNIT_SCENE.instantiate()
		%Units.add_child(new_unit)
		new_unit.setup(saved_unit.position, saved_unit.target_position, saved_unit.data, saved_unit.state_name)


func get_units() -> Array[SavedUnit]:
	var units: Array[SavedUnit] = []
	for child: Unit in %Units.get_children():
		var saved_unit := SavedUnit.new()
		saved_unit.position = child.position
		saved_unit.target_position = child.target_position
		saved_unit.data = child.data
		saved_unit.state_name = child.fsm.state.name
		units.append(saved_unit)
	return units


func is_unit_selected(selection_rect: Rect2, unit: Unit) -> bool:
	var unit_pos: Vector2 = world_camera.camera.unproject_position(unit.global_position)
	return selection_rect.has_point(unit_pos)


func select_units(selection_rect: Rect2) -> void:
	while not selected_units.is_empty():
		selected_units.pop_front().unselect()
	for unit: Unit in %Units.get_children():
		if is_unit_selected(selection_rect, unit):
			selected_units.append(unit)
			unit.select()
