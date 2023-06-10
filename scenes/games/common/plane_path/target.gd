extends Area2D

var plane_id :int = 0

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id


func _on_area_entered(area):
	if area.get_plane_id() == plane_id:
		Events.trigger("plane_arrived", plane_id) # Replace with function body.
