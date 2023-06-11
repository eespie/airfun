extends Node2D


var plane_path_scene: PackedScene = preload("res://scenes/games/common/plane_path/plane_path.tscn")
@export var margin :int = 100

var terrain :TextureRect

var plane_id :int = 0
var plane_count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	terrain = get_tree().get_first_node_in_group("terrain")
	bind_events()

func bind_events():
	Events.register("mouse_drag", self)
	Events.register("mouse_button_clicked", self)
	Events.register("mouse_button_released", self)
	Events.register("plane_arrived", self)

func _exit_tree():
	Events.unregister_node(self)

func _on_mouse_drag(mouse: Vector2i):
	$Mouse.position = mouse
	
func _on_mouse_button_clicked(mouse: Vector2i):
	$Mouse.position = mouse
		
	
func _on_mouse_button_released(_mouse: Vector2i):
	$Mouse.position = Vector2(-100, -100)

func get_color(mouse:Vector2i):
	var color :Color = terrain.get_texture().get_image().get_pixel(mouse.x, mouse.y)
	return color
	
func get_target_pos() -> Vector2:
	while true:
		var target_pos = Vector2(randi_range(margin, 1920 - margin), randi_range(margin, 1080 - margin));
		var color = get_color(target_pos)
		if color.g > color.r and color.g > color.b:
			return target_pos
	return Vector2(0, 0)

func _on_plane_pop_timer_timeout():
	if plane_count > 5:
		return
		
	var plane_path = plane_path_scene.instantiate()
	plane_id += 1
	plane_count += 1
	plane_path.set_plane_id(plane_id)
	$Planes.add_child(plane_path)
	
	var target_pos = get_target_pos();
	plane_path.set_target_pos(target_pos)
	
	var plane_pos = Vector2(randi_range(margin, 1920 - margin), randi_range(margin, 1080 - margin));
	plane_path.set_plane_pos(plane_pos)
	Events.trigger("timer_next", randi_range(5, 10))
	

func _on_plane_arrived(_id: int):
	Events.trigger("increment_score")
	plane_count -= 1
	Events.trigger("timer_next", randf_range(0.1, 2.0))
