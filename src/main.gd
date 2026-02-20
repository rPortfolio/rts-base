extends Node


var unit_scene: PackedScene = preload("res://src/world/unit/unit.tscn")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		add_unit()
	elif event.is_action_pressed("right_click"):
		call_units()


func add_unit() -> void:
	var new_unit: Unit = unit_scene.instantiate()
	new_unit.position = %WorldCamera.get_cursor_position()
	%Units.add_child(new_unit)


func call_units() -> void:
	for child: Unit in %Units.get_children():
		child.target_position = %WorldCamera.get_cursor_position()
