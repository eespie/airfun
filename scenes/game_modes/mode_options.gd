extends VFlowContainer

func _ready() -> void:
	Sound.play_sfx($EnterSFX)

func _on_button_mouse_entered() -> void:
	Sound.play_sfx($Over)

func _on_random_pressed():
	Events.trigger("change_scene", "games/random_fun/random_fun")


func _on_transit_pressed():
	pass # Replace with function body.


func _on_landing_pressed():
	pass # Replace with function body.


func _on_back_pressed():
	Events.trigger("change_scene", "main_menu/main_menu")
