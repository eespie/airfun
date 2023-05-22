@tool
extends Node

var current_scene: Node

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	bind_events()
	
func bind_events() -> void:
	Events.register("change_scene", self, Events.DEFERRED)
	Events.register("change_scene_root", self, Events.DEFERRED)

func _on_change_scene(path: String) -> void:
	self._on_change_scene_root(path, get_tree())

func _on_change_scene_root(path: String, tree: SceneTree) -> void:
	var s = ResourceLoader.load("scenes/" + path + ".tscn")
	if s == null:
		return
	current_scene.queue_free()
	current_scene = s.instantiate()
	if tree == null:
		tree = get_tree()
	tree.get_root().add_child(current_scene)
	tree.set_current_scene( current_scene )

func cleanup_group(group_name):
	var nodes = get_tree().get_nodes_in_group(group_name)
	for node in nodes:
		node.queue_free()
