extends VFlowContainer

func _on_main_menu_pressed() -> void:
	var root = get_tree().get_root().get_tree()
	root.paused = false
	Events.trigger("change_scene_root", "main_menu/main_menu", get_tree().get_root().get_tree())
