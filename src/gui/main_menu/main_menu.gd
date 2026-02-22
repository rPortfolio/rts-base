extends Control


signal game_selected(slot: int, game: SavedGame)


const SAVE_FOLDER = "user://saves/"
const SAVE_FILE_PREFIX = "save" ## All files will start with save
const SAVE_SLOT_NUMBER = 3
const SAVED_GAME_PANEL = preload("res://src/gui/main_menu/saved_game_panel.tscn")
const NEW_GAME_PANEL = preload("res://src/gui/main_menu/new_game_panel.tscn")


var open_slot := 1 ## Slot currently being modified


func _ready() -> void:
	refresh_save_display()


func refresh_save_display() -> void:
	## Clear save display container
	for child in %SaveDisplayContainer.get_children():
		child.queue_free()
	## Create panels for saved games
	var saved_games := get_saved_games()
	for i in range(SAVE_SLOT_NUMBER):
		var save := saved_games[i]
		var save_number := i + 1
		if save:
			var panel = SAVED_GAME_PANEL.instantiate()
			panel.setup(save_number, save.player, save.level, save.time, self)
			%SaveDisplayContainer.add_child(panel)
		else:
			var panel = NEW_GAME_PANEL.instantiate()
			panel.setup(save_number, self) ## Dependency injects reference to the main menu for signal connection purposes
			%SaveDisplayContainer.add_child(panel)


func get_saved_games() -> Array[SavedGame]:
	## Create an typed array with a number of null elements equal to the number of save slots
	var saved_games: Array[SavedGame] = []
	saved_games.resize(SAVE_SLOT_NUMBER)
	saved_games.fill(null)
	## Replace null values with SavedGames for save slots with content
	var dir := DirAccess.open(SAVE_FOLDER)
	if dir:
		for i in range(SAVE_SLOT_NUMBER):
			var save_number := i + 1
			var file_path := "{}{}{}.tres".format([SAVE_FOLDER, SAVE_FILE_PREFIX, str(save_number)], "{}")
			if FileAccess.file_exists(file_path):
				saved_games[i] = ResourceLoader.load(file_path)
	return saved_games


func save_game(slot: int, save: SavedGame) -> void:
	if !DirAccess.dir_exists_absolute(SAVE_FOLDER):
		DirAccess.make_dir_absolute(SAVE_FOLDER)
	var file_path := "{}{}{}.tres".format([SAVE_FOLDER, SAVE_FILE_PREFIX, str(slot)], "{}")
	ResourceSaver.save(save, file_path)
	refresh_save_display()


func delete_game(slot: int) -> void:
	var file_path := "{}{}{}.tres".format([SAVE_FOLDER, SAVE_FILE_PREFIX, str(slot)], "{}")
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)
		refresh_save_display()


## Creates a new save with just a name
func init_save(player_name: String) -> void:
	var save := SavedGame.new()
	save.player = player_name
	save_game(open_slot, save)


func _on_new_game_button_pressed(save_number: int) -> void:
	open_slot = save_number
	%NamePanel.open()


func _on_select_save_button_pressed(save_number: int) -> void:
	var save_index := save_number - 1
	game_selected.emit(save_number, get_saved_games()[save_index])


func _on_delete_save_button_pressed(save_number: int) -> void:
	delete_game(save_number)


func _on_name_panel_name_entered(player_name: String) -> void:
	init_save(player_name)
	%NamePanel.hide()


func _on_name_panel_cancelled() -> void:
	%NamePanel.hide()
