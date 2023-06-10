extends Sprite2D

var plane_id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	Events.register("plane_select", self)
		
func _exit_tree():
	Events.unregister_node(self)

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

func _on_plane_select(selected: bool, id: int):
	if plane_id == id:
		if selected:
			show()
		else:
			hide()
