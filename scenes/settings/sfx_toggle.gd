extends CheckButton

func _ready() -> void:
	set_pressed_no_signal(Global.play_sfx)

func _on_toggled(bpressed: bool) -> void:
	get_parent().button_clicked()
	Global.set_setting("play_sfx", bpressed)
