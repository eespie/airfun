extends Node2D

var full_duration: float = 0.0
var elapsed: float = 0.0

@onready var images = [
	$Explosion00,
	$Explosion01,
	$Explosion02,
	$Explosion03,
	$Explosion04,
	$Explosion05,
	$Explosion06,
	$Explosion07,
	$Explosion08
]

var plane_id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_bind_events()

func _bind_events():
	Events.register("plane_crashed", self)
		
func _exit_tree():
	Events.unregister_node(self)

func set_plane_id(id: int):
	plane_id = id

func get_plane_id():
	return plane_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	elapsed += delta
	if elapsed > full_duration:
		return
	
	var progress: int = roundi(elapsed / full_duration * 8.0)
	images[clampi(progress - 2, 0, 8)].hide()
	images[clampi(progress, 0, 8)].show();

func _on_plane_crashed(id: int):
	if plane_id != id:
		return
		
	explode()

func explode(duration: float = 0.5):
	get_children().all(hide_image)
	full_duration = duration
	elapsed = 0.0
	Sound.play_sfx($ExplodeSFX)

func hide_image(image):
	image.hide()
	return true
