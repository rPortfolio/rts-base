extends PanelContainer


signal name_entered(player_name: String)
signal cancelled



func _gui_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		cancelled.emit()


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
