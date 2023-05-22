extends Node2D

@export var game_name: String:
	get:
		return game_name

func _ready():
	Events.trigger("new_game", game_name)
	
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")
		
func _pause() -> void:
	$GUI/Paused.pause()
	get_tree().paused = true

