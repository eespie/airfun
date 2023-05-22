extends VFlowContainer

func _ready() -> void:
	if !OS.has_feature("pc"):
		$Quit.hide()

func _on_quit_pressed() -> void:
	get_tree().get_root().get_tree().quit()

func _on_main_menu_pressed() -> void:
	var root = get_tree().get_root().get_tree()
	root.paused = false
	Events.trigger("change_scene_root", "main_menu/main_menu", get_tree().get_root().get_tree())
