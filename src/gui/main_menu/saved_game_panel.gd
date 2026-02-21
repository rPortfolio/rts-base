extends PanelContainer


func setup(number: int, player: StringName, level: int, time: StringName, main_menu: Node) -> void:
	%SaveNumber.text = "SAVE {}".format([number], "{}")
	%PlayerName.text = player
	%LevelsCompleted.text = "Level {}".format([level], "{}")
	%TimePlayed.text = time
	%DeleteSave.pressed.connect(main_menu._on_delete_save_button_pressed.bind(number))
