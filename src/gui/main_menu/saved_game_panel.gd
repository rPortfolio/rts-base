extends PanelContainer


func setup(number: int, player: StringName, level: int, time: StringName) -> void:
	%SaveNumber.text = "SAVE {}".format([number], "{}")
	%PlayerName.text = player
	%LevelsCompleted.text = "Level {}".format([level], "{}")
	%TimePlayed.text = time
