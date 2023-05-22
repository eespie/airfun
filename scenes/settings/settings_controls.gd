extends VFlowContainer

func _ready() -> void:
	Sound.play_sfx($EnterSFX)

func _on_mouse_entered():
	Sound.play_sfx($OverSFX)

func button_clicked() -> void:
	Sound.play_sfx($ClickSFX)
