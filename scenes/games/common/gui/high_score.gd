extends Label

var high_score = 0
var game_name = ""

func _ready():
	bind_events()

func bind_events() -> void:
	Events.register("new_high_score", self)
	Events.register("new_game", self)

func _exit_tree():
	Events.unregister_node(self)

func display_high_score() -> void:
	text = "HighScore " + str(high_score)

func _on_new_game(mode_name: String) ->void:
	game_name = mode_name
	high_score = GameInfo.get_value(game_name, "high_score", 0)
	display_high_score()

func _on_new_high_score(score: int) -> void:
	if score <= high_score:
		return
	high_score = score
	GameInfo.save_value(game_name, "high_score", high_score)
	display_high_score()
