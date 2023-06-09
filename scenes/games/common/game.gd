extends Node2D

@export var game_name: String:
	get:
		return game_name
@export var initial_wait_time :float = 0.5


enum mouse_states {RELEASED, CLICKED}

var mouse_state: mouse_states = mouse_states.RELEASED

func _ready():
	bind_events()
	Events.trigger("new_game", game_name)
	Events.trigger("timer_next", initial_wait_time)
	Events.register("plane_crashed", self)

func bind_events() -> void:
	Events.register("timer_next", self)
	
func _exit_tree():
	Events.unregister_node(self)
	
	
func _process(_delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and mouse_state == mouse_states.CLICKED:
		Events.trigger("mouse_drag", event.position)
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_state = mouse_states.CLICKED
			Events.trigger("mouse_button_clicked", event.position)
		else:
			mouse_state = mouse_states.RELEASED
			Events.trigger("mouse_button_released", event.position)

func _on_timer_next(wait_time: float):
	$PlanePopTimer.start(wait_time)
	
func _on_plane_crashed(_plane_id: int):
	if $GameOverTimer.is_stopped():
		$GameOverTimer.start(1.0)

func _on_game_over_timer_timeout():
	$GUI.game_over()
