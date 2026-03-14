extends Node3D


const CAM_SPEED := 5.0
var is_rotating := false
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
	var direction := Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up").rotated(camera.rotation.y)
	position.x += direction.x * CAM_SPEED * delta
	position.z -= direction.y * CAM_SPEED * delta ## Forward is positive for Z
	if is_rotating:
		return
	if Input.is_action_just_pressed("rotate_camera_left"):
		rotate_camera(PI/2)
	elif Input.is_action_just_pressed("rotate_camera_right"):
		rotate_camera(-PI/2)


func rotate_camera(amount: float) -> void:
	is_rotating = true
	await create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).tween_property(camera, "rotation:y", camera.rotation.y + amount, 0.2).finished
	is_rotating = false



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
