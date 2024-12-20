extends Node2D

@onready var path2D : Path2D = $Path2D
@onready var pathFollow2D :PathFollow2D = $Path2D/PathFollow2D
@onready var plane = $Path2D/PathFollow2D/PLane
@onready var plane_warning = $Path2D/PathFollow2D/PlaneWarning
@onready var curve: Curve2D
@onready var target = $Target
@onready var trajectory = $Trajectory
@onready var highlight_plane = %HighlightPlane

@export var waiting_radius :float = 50.0

var segment_length = 20
var screen_center = Vector2(Global.WIDTH/2, Global.HEIGHT/2)
var speed = 50
var progress = 0.0
var selected : bool = false
# last point on curve
var last_point: Vector2
# last vector on curve
var last_vector: Vector2
var plane_id :int = 0
var plane_selected :int = 0

enum PlaneState {WAITING, RUNNING, CRASHED}
var plane_state: PlaneState = PlaneState.WAITING

var plane_warned = []
var fuel :float = 60.0

var border_limit = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	Events.register("mouse_drag", self)
	Events.register("mouse_button_released", self)
	Events.register("mouse_button_clicked", self)
	Events.register("plane_select", self)
	Events.register("plane_arrived", self)
	Events.register("plane_crashed", self)
	Events.register("plane_warning_start", self)
	Events.register("plane_warning_end", self)
		
func _exit_tree():
	Events.unregister_node(self)
	
func _process(delta):
	if plane_state == PlaneState.CRASHED:
		return
		
	if plane_state == PlaneState.WAITING:
		highlight_plane.show()
	else:
		highlight_plane.hide()
		
	var curve_len = curve.get_baked_length()
	progress += delta * speed
	while progress > curve_len:
		progress -= curve_len
	pathFollow2D.set_progress(progress)

	var current_transformation = curve.sample_baked_with_rotation(progress)
	var current_rotation = current_transformation.get_rotation()
	var cur_pos = current_transformation.get_origin()
	
	# Check screen boundaries
	if cur_pos.x < border_limit or cur_pos.x > Global.WIDTH - border_limit or cur_pos.y < border_limit or cur_pos.y > Global.HEIGHT - border_limit:
		if plane_warned.find(plane_id) == -1:
			Events.trigger("plane_warning_start", plane_id)
		if cur_pos.x < 0 or cur_pos.x > Global.WIDTH or cur_pos.y < 0 or cur_pos.y > Global.HEIGHT:
			if plane_state != PlaneState.CRASHED:
				Events.trigger("plane_crashed", plane_id)
	
	# Trajectory
	trajectory.clear_points()
	if plane_state == PlaneState.RUNNING:
		trajectory.show()
		var points = curve.get_baked_points()
		var curve_index: int = points.size() - 2
		var trajectory_progress = curve.get_closest_offset(points[curve_index])
		while trajectory_progress > progress:
			curve_index -= 1
			trajectory.add_point(points[curve_index])
			trajectory_progress = curve.get_closest_offset(points[curve_index])
	

func set_plane_id(id: int):
	plane_id = id
	
func set_target_pos(pos: Vector2):
	target.set_position(pos)
	var plane_color = Color.from_ok_hsl(randf_range(0.0, 1.0), randf_range(0.8, 1.0), randf_range(0.8, 1.0))
	target.modulate = plane_color
	plane.modulate = plane_color
	propagate_call("set_plane_id", [plane_id])
	
func set_plane_pos(pos:Vector2):
	curve = Curve2D.new()
	curve.clear_points()
	curve.bake_interval = segment_length
	path2D.set_curve(curve)
	
	print(str("Plane ", plane_id, " set pos ", pos))

	# build a waiting circle
	var angle = 2 * PI / 10
	for i in range(11):
		var point = pos + waiting_radius * Vector2(sin(i * angle), cos(i * angle))
		curve.add_point(point)
	_smooth()
	pathFollow2D.set_progress(0.0)
	pathFollow2D.set_loop(true)
	# Ignore collisions
	plane.monitorable = false
	plane.monitoring = false
	plane_warning.monitorable = false
	plane_warning.monitoring = false
	
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
	i = clampi(i, 0, curve.get_point_count() - 1)
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
		return # click did not hit plane
	
	_select(true)
	# Allow collisions
	plane.monitorable = true
	plane.monitoring = true
	plane_warning.monitorable = true
	plane_warning.monitoring = true
	plane_state = PlaneState.RUNNING
	var plane_pos = current_position
	curve.clear_points()
	curve.add_point(plane_pos)
	last_point = mouse
	last_vector = plane_pos.direction_to(mouse)
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
		
	# Mouse arrive on target
	if target.position.distance_to(mouse) < 32:
		_select(false)
		curve.add_point(target.position)
		_smooth()
		return
		
	if last_point.distance_to(mouse) < segment_length:
		return
		
	var current_vector = last_point.direction_to(mouse)
	if abs(last_vector.angle_to(current_vector)) < PI/2.0:
		curve.add_point(mouse)
		last_vector = current_vector
		last_point = mouse
		_smooth()


func _on_plane_arrived(id: int):
	if plane_id == id:
		queue_free()

func _on_plane_warning_start(id: int):
	plane_warned.append(id)

func _on_plane_warning_end(id: int):
	plane_warned.erase(id)
	
func _on_plane_crashed(id: int):
	if id == plane_id:
		plane_state = PlaneState.CRASHED
