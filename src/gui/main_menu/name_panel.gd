extends PanelContainer


signal name_entered(player_name: String)
signal cancelled


func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		cancelled.emit()
		get_viewport().set_input_as_handled()


func open() -> void:
	%NameEntry.text = ""
	show()
	%NameEntry.grab_focus()


func _on_name_entry_text_submitted(new_text: String) -> void:
	name_entered.emit(new_text)


func _on_accept_pressed() -> void:
	name_entered.emit(%NameEntry.text)


func _on_cancel_button_down() -> void:
	cancelled.emit()


func _on_name_entry_editing_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		cancelled.emit()
