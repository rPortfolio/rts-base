extends PanelContainer


func setup(number: int, main_menu: Node) -> void:
	%SaveNumber.text = "SAVE {}".format([number], "{}")
	%NewGame.pressed.connect(main_menu._on_new_game_button_pressed.bind(number))
