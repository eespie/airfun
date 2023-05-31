extends Node2D

@export var game_name: String:
	get:
		return game_name

var mouse = Vector2()

func _ready():
	Events.trigger("new_game", game_name)
	
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")
	if event is InputEventMouse:
		mouse = event.position
	if event is InputEventMouseButton and event.is_pressed():
		get_color()
				
func _pause() -> void:
	$GUI/Paused.pause()
	get_tree().paused = true


func get_color():
	var terrain = get_tree().get_first_node_in_group("terrain")
	
	
