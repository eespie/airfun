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
	var savegame = FileAccess.open(save_file, FileAccess.READ)
	var savedict = {}
	var content = savegame.get_line()
	#print(content)
	var json = JSON.new()
	savedict = json.parse(content)
	savegame.close()
	return savedict.get_data()
