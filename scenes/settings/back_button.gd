extends Button

func _on_pressed() -> void:
	Events.trigger("change_scene", "main_menu/main_menu")
