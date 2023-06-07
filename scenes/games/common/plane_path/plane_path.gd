extends Node2D

@onready var path2D = $Path2D
@onready var curve2D = path2D.curve
@onready var pathFollow2D :PathFollow2D = $Path2D/PathFollow2D
@onready var plane :Area2D = $Path2D/PathFollow2D/Plane
@onready var curve: Curve2D = $Path2D.get_curve()

@export var waiting_radius :float = 50.0
var screen_center = Vector2(960, 540)
var speed = 20
var progress = 0.0
var selected : bool = false
var last_point

# Called when the node enters the scene tree for the first time.
func _ready():
	bind_events()

func _process(delta):
	var curve_len = curve.get_baked_length()
	progress += delta * speed
	while progress > curve_len:
		progress -= curve_len
	pathFollow2D.set_progress(progress)

func bind_events():
	Events.register("mouse_drag", self)
	Events.register("mouse_button_released", self)
	
func set_target_pos(pos: Vector2):
	$Target.set_position(pos)
	
func set_plane_pos(pos:Vector2):
	curve.clear_points()

	# build a waiting circle
	var angle = 2 * PI / 10
	for i in range(11):
		var point = pos + waiting_radius * Vector2(sin(i * angle), cos(i * angle))
		curve.add_point(point)
	smooth()
	pathFollow2D.set_progress(0.0)
	pathFollow2D.set_loop(true)
	
func smooth():
	var point_count = curve.get_point_count()
	for i in point_count:
		var spline = _get_spline(i)
		curve.set_point_in(i, -spline)
		curve.set_point_out(i, spline)

func _get_spline(i):
	var last_point = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	var spline = last_point.direction_to(next_point) * 10
	return spline

func _get_point(i):
	var point_count = curve.get_point_count()
	i = wrapi(i, 0, point_count - 1)
	return curve.get_point_position(i)
	

func select(is_selected: bool):
	selected = is_selected
	if selected:
		for node in get_tree().get_nodes_in_group("select"):
			node.show()
	else:
		for node in get_tree().get_nodes_in_group("select"):
			node.hide()


func _on_plane_body_entered(body):
	select(true)
	var plane_pos = curve.get_closest_point(body.position)
	curve.clear_points()
	curve.add_point(plane_pos)
	last_point = body.position
	curve.add_point(last_point)
	smooth()
	pathFollow2D.set_loop(false)
	progress = 0.0


func _on_mouse_button_released(mouse: Vector2):
	if not selected:
		return

	select(false)
	var point_idx = curve.get_point_count() - 2
	var p1 = curve.get_point_position(point_idx)
	var p2 = curve.get_point_position(point_idx + 1)
	var last = p1 + p1.direction_to(p2) * 2000.0
	curve.add_point(last)
	
	

func _on_mouse_drag(mouse: Vector2):
	if not selected:
		return

	if last_point == null:
		last_point = mouse
	var increment = mouse - last_point
	if increment.length() > 20:
		curve.add_point(mouse)
		last_point = mouse
		smooth()


func _on_target_body_entered(body):
	pass
	if not selected:
		return
		
	select(false)
	var last = $Target.position
	curve.add_point(last)

