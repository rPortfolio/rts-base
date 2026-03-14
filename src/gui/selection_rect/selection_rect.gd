extends ColorRect


var click_pos: Vector2


func _ready() -> void:
	Events.area_selected.connect(_on_area_selected)
	#hide()


func _on_area_selected(selection_rect: Rect2) -> void:
	if selection_rect.size == Vector2.ZERO:
		hide()
	else:
		show()
	position = selection_rect.position
	size = selection_rect.size


#func _process(_delta: float) -> void:
	#var mouse_pos := get_viewport().get_mouse_position()
	#position.x = min(click_pos.x, mouse_pos.x)
	#position.y = min(click_pos.y, mouse_pos.y)
	#
	#size.x = max(click_pos.x, mouse_pos.x) - position.x
	#size.y = max(click_pos.y, mouse_pos.y) - position.y
#
#
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("mid_click"):
		#click_pos = get_viewport().get_mouse_position()
		#show()
	#elif event.is_action_released("mid_click") and visible:
		#hide()
		#Events.selection_made.emit(Rect2(
			#position.x,
			#position.y,
			#size.x,
			#size.y
		#))
