extends Area2D


var plane_id :int = 0

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

# Warning collision
func _on_area_entered(_area):
	Events.trigger("plane_warning_collision_start", plane_id)


func _on_area_exited(area):
	Events.trigger("plane_warning_collision_end", plane_id)