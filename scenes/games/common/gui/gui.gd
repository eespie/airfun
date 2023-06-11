extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_pause")
				
func _pause() -> void:
	$Paused.pause()
	get_tree().paused = true
	
func game_over() -> void:
	$GameOver.game_over()
	get_tree().paused = true
