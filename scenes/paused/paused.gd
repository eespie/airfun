extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_released("pause"):
		call_deferred("_resume")

func _resume() -> void:
	hide()
	var root = get_tree().get_root().get_tree()
	root.paused = false

func pause() -> void:
	Sound.play_sfx($PauseSFX)
	show()
