extends Control


const SAVE_FOLDER = "user://saves/"
const SAVE_PATH_TEMPLATE = "user://saves/{}.tres"


func _ready() -> void:
	refresh_save_display()


func refresh_save_display() -> void:
	for child in %SaveDisplayContainer.get_children():
		child.queue_free()
	var saved_games := get_saved_games()
	for i in range(saved_games.size()):
		var save = saved_games[i]
		var panel = load("res://src/gui/main_menu/saved_game_panel.tscn").instantiate()
		panel.setup(i + 1, save.player, save.level, save.time)
		%SaveDisplayContainer.add_child(panel)


func get_saved_games() -> Array[SavedGame]:
	var saved_games: Array[SavedGame] = []
	var dir := DirAccess.open(SAVE_FOLDER)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name:
			var save: SavedGame = ResourceLoader.load(SAVE_FOLDER + file_name)
			saved_games.append(save)
			file_name = dir.get_next()
	return saved_games


func _on_save_pressed() -> void:
	if !DirAccess.dir_exists_absolute("user://saves"):
		DirAccess.make_dir_absolute("user://saves")
	var save := SavedGame.new()
	save.player = %PlayerName.text
	save.time = %TimePlayed.text
	save.level = int(%LevelsCompleted.text)
	var save_path := "{}save{}.tres".format([SAVE_FOLDER, int(%FileNo.text)], "{}")
	print(save_path)
	ResourceSaver.save(save, save_path)
	refresh_save_display()
