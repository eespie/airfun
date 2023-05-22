extends Node

var game_info = []

func _ready():
	game_info = File.load_game()
	
func get_value(game: String, value_name: String, default):
	var info = game_info.get(game)
	if info == null:
		return default
	
	var value = info.get(value_name)
	if value == null:
		return default
	
	return value

func save_value(game: String, value_name: String, value) -> void:
	var info = game_info.get(game)
	if info == null:
		info = []
	
	info.set(value_name, value)
	game_info.set(game, info)
	
	File.save_game(game_info)
