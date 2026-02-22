extends Node3D


const UNIT_SCENE: PackedScene = preload("res://src/world/unit/unit.tscn")
@onready var camera: Camera3D = %WorldCamera


func _unhandled_input(event: InputEvent) -> void:
	if camera.is_cursor_on_screen():
		if event.is_action_pressed("left_click"):
			add_unit()
		elif event.is_action_pressed("right_click"):
			call_units()


func add_unit() -> void:
	var new_unit: Unit = UNIT_SCENE.instantiate()
	new_unit.position = camera.get_cursor_position()
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
		new_unit.target_position = saved_unit.position
		%Units.add_child(new_unit)


func get_units() -> Array[SavedUnit]:
	var units: Array[SavedUnit] = []
	for child: Unit in %Units.get_children():
		var saved_unit := SavedUnit.new()
		saved_unit.position = child.position
		saved_unit.target_position = child.target_position
		units.append(saved_unit)
	return units
