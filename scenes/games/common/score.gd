extends Label

var high_score = 0
var score = 0
var game_name = ""

func _ready():
	bind_events()
	
func bind_events() -> void:
	Events.register("increment_score", self)
	Events.register("new_game", self)

func _exit_tree():
	Events.unregister_node(self)

func _on_new_game(name: String) ->void:
	game_name = name
	high_score = GameInfo.get_value(game_name, "high_score", 0)

func _on_increment_score() ->void:
	score = score + 1
	text = "Score " + str(score)
	if score > high_score:
		high_score = score
		Events.trigger("new_high_score", game_name, high_score)

