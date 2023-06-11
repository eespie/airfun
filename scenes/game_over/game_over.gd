extends Control

func game_over() -> void:
	Sound.play_sfx($GameOverSFX)
	show()
