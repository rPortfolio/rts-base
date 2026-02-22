extends Node


enum States {
	MAIN_MENU,
	PLAYING,
}

var state: States = States.MAIN_MENU:
	set = set_state


var saved_game: SavedGame
var open_slot: int


func _unhandled_input(event: InputEvent) -> void:
	match state:
		States.MAIN_MENU:
			if event.is_action_pressed("ui_cancel"):
				get_tree().quit()
		States.PLAYING:
			if event.is_action_pressed("ui_cancel"):
				state = States.MAIN_MENU


func set_state(new_state) -> void:
	match state:
		States.PLAYING:
			saved_game.units = %World.get_units()
			saved_game.camera_pos = %World.camera.position
			%MainMenu.save_game(open_slot, saved_game)
			%World.kill_units()
	match new_state:
		States.MAIN_MENU:
			%MainMenu.show()
		States.PLAYING:
			%World.load_units(saved_game.units)
			%World.camera.position = saved_game.camera_pos
			%MainMenu.hide()
	state = new_state


func _on_main_menu_game_selected(slot: int, game: SavedGame) -> void:
	saved_game = game
	open_slot = slot
	%PlayerName.text = saved_game.player
	state = States.PLAYING
