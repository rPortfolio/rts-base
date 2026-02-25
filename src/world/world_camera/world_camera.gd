extends Node3D


const CAM_SPEED := 5.0
@onready var camera: Camera3D = %Camera3D


func _physics_process(delta: float) -> void:
	move_camera(delta)
	point_raycast()
	if %RayCast3D.is_colliding():
		%Cursor.show()
		%Cursor.global_position = %RayCast3D.get_collision_point()
	else:
		%Cursor.hide()


func move_camera(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	position.x += direction.x * CAM_SPEED * delta
	position.z -= direction.y * CAM_SPEED * delta ## Forward is positive for Z


func point_raycast() -> void:
	const projection_distance = 1^999 ## Must be really large to make cursor follow mouse accurately
	var projected_pos := camera.project_position(get_viewport().get_mouse_position(), projection_distance)
	projected_pos -= position ## Make position relative
	%RayCast3D.target_position = projected_pos


func get_cursor_position() -> Vector3:
	if %RayCast3D.is_colliding():
		return %RayCast3D.get_collision_point()
	return %Cursor.global_position ## Should be last valid position


func is_cursor_on_screen() -> bool:
	return %RayCast3D.is_colliding()
