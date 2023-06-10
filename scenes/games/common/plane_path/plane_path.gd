extends Node2D

@onready var path2D : Path2D = $Path2D
@onready var pathFollow2D :PathFollow2D = $Path2D/PathFollow2D
@onready var plane = $Path2D/PathFollow2D/PLane
@onready var curve: Curve2D
@onready var target = $Target

@export var waiting_radius :float = 50.0
var screen_center = Vector2(960, 540)
var speed = 50
var progress = 0.0
var selected : bool = false
var last_point

var plane_id :int = 0

var plane_selected :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	Events.register("mouse_drag", self)
	Events.register("mouse_button_released", self)
	Events.register("mouse_button_clicked", self)
	Events.register("plane_select", self)
	Events.register("plane_arrived", self)
		
func _exit_tree():
	Events.unregister_node(self)
	
func _process(delta):
	var curve_len = curve.get_baked_length()
	progress += delta * speed
	while progress > curve_len:
		progress -= curve_len
	pathFollow2D.set_progress(progress)
	
func set_plane_id(id: int):
	plane_id = id
	
func set_target_pos(pos: Vector2):
	target.set_position(pos)
	propagate_call("set_plane_id", [plane_id])
	
func set_plane_pos(pos:Vector2):
	curve = Curve2D.new()
	path2D.set_curve(curve)
	
	print(str("Plane ", plane_id, " set pos ", pos))
	curve.clear_points()

	# build a waiting circle
	var angle = 2 * PI / 10
	for i in range(11):
		var point = pos + waiting_radius * Vector2(sin(i * angle), cos(i * angle))
		curve.add_point(point)
	_smooth()
	pathFollow2D.set_progress(0.0)
	pathFollow2D.set_loop(true)
	
func _smooth():
	var point_count = curve.get_point_count()
	for i in point_count:
		var spline = _get_spline(i)
		curve.set_point_in(i, -spline)
		curve.set_point_out(i, spline)

func _get_spline(i):
	var last_pt = _get_point(i - 1)
	var next_point = _get_point(i + 1)
	var spline = last_pt.direction_to(next_point) * 10
	return spline

func _get_point(i):
	var point_count = curve.get_point_count()
	i = wrapi(i, 0, point_count - 1)
	return curve.get_point_position(i)
	

func _select(is_selected: bool):
	selected = is_selected
	Events.trigger("plane_select", selected, plane_id)
	
func _on_plane_select(select :bool, id :int):
	if select:
		plane_selected = id
	else:
		plane_selected = 0

func _on_mouse_button_clicked(mouse: Vector2):
	if plane_selected != 0:
		return
		
	var current_position = curve.sample_baked(progress)
	if current_position.distance_to(mouse) > 32:
		return
	_select(true)
	var plane_pos = curve.get_closest_point(mouse)
	curve.clear_points()
	curve.add_point(plane_pos)
	last_point = mouse
	curve.add_point(last_point)
	_smooth()
	pathFollow2D.set_loop(false)
	progress = 0.0


func _on_mouse_button_released(_mouse: Vector2):
	if not selected:
		return

	_select(false)
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
	if increment.length() > 30:
		curve.add_point(mouse)
		last_point = mouse
		_smooth()
	# Mouse arrive on target
	if target.position.distance_to(mouse) < 32:
		_select(false)
		var last = target.position
		curve.add_point(last)

func _on_plane_arrived(id: int):
	if plane_id == id:
		queue_free()
	