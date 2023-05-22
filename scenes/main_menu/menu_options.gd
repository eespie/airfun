extends VFlowContainer

func _ready() -> void:
	Sound.play_sfx($EnterSFX)
	
	if !OS.has_feature("pc"):
		$Quit.hide()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	Events.trigger("change_scene", "settings/settings")

func _on_start_pressed() -> void:
	Events.trigger("change_scene", "gameplay/gameplay")

func _on_button_mouse_entered() -> void:
	Sound.play_sfx($Over)

