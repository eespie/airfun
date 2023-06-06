extends Node2D


@export var plane_path_scene: PackedScene
@export var margin :int = 100

var terrain :TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain = get_tree().get_first_node_in_group("terrain")
	bind_events()

func bind_events():
	Events.register("mouse_drag", self)
	Events.register("mouse_button_clicked", self)
	Events.register("mouse_button_released", self)

func _exit_tree():
	Events.unregister_node(self)

func _on_mouse_drag(mouse: Vector2):
	pass
	
func _on_mouse_button_clicked(mouse: Vector2):
	pass
	
func _on_mouse_button_released(mouse: Vector2):
	pass

func get_color(mouse:Vector2):
	var color :Color = terrain.get_texture().get_image().get_pixel(mouse.x, mouse.y)
	return color
	
func get_target_pos() -> Vector2:
	while true:
		var target_pos = Vector2(randi_range(margin, 1920 - margin), randi_range(margin, 1080 - margin));
		var color = get_color(target_pos)
		if color.g > color.r and color.g > color.b:
			return target_pos
	return Vector2(0, 0)

func _on_timer_timeout():
	var plane_path = plane_path_scene.instantiate()
	$Planes.add_child(plane_path)
	
	var target_pos = get_target_pos();
	plane_path.set_target_pos(target_pos)
	
	var plane_pos = Vector2(randi_range(margin, 1920 - margin), randi_range(margin, 1080 - margin));
	plane_path.set_plane_pos(plane_pos)
	

