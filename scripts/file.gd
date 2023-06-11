extends Node

const save_file = "user://airfun.save"

func _ready():
	pass

func save_game(savedict) -> void:
	var savegame = FileAccess.open(save_file, FileAccess.WRITE)
	savegame.store_line(JSON.stringify(savedict))
	savegame.close()

func load_game() -> Dictionary:
	if not FileAccess.file_exists(save_file):
		return {}
	#var savegame = FileAccess.open(save_file, FileAccess.READ)
	var savedict = {}
	var content = FileAccess.get_file_as_string(save_file)
	savedict = JSON.parse_string(content)
	#savegame.close()
	return savedict
