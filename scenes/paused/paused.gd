extends Control

var isPaused: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause") and isPaused:
		call_deferred("_resume")

func _resume() -> void:
	hide()
	var root = get_tree().get_root().get_tree()
	root.paused = false
	isPaused = false

func pause() -> void:
	isPaused = true
	Sound.play_sfx($PauseSFX)
	show()
