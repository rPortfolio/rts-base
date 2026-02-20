extends Node


var unit_scene: PackedScene = preload("res://src/world/unit/unit.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		_on_add_unit_pressed()
	elif event.is_action_pressed("right_click"):
		_on_call_units_pressed()


func _on_add_unit_pressed() -> void:
	var new_unit: Unit = unit_scene.instantiate()
	new_unit.position = %WorldCamera.get_cursor_position()
	%Units.add_child(new_unit)


func _on_call_units_pressed() -> void:
	for child: Unit in %Units.get_children():
		child.target_position = %WorldCamera.get_cursor_position()
