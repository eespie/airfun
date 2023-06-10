extends Sprite2D


var plane_id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	Events.register("plane_warning_collision_start", self)
	Events.register("plane_warning_collision_end", self)
		
func _exit_tree():
	Events.unregister_node(self)

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

func _on_plane_warning_collision_start(id: int):
	if plane_id == id:
		show()

func _on_plane_warning_collision_end(id: int):
	if plane_id == id:
		hide()

