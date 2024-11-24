extends TextureRect

func _ready():
	get_texture().noise.set_seed(randi())
	
