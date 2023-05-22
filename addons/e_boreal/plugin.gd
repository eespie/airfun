@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("Events", "res://addons/e_boreal/events.gd")
	add_autoload_singleton("Scene", "res://addons/e_boreal/scene.gd")

func _exit_tree():
	remove_autoload_singleton("Events")
	remove_autoload_singleton("Scene")
