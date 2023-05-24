extends TileMap

@export var ratio: float
@export var water_height: float

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 256
var height = 256


func _ready() -> void:
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.05
	generate_chunk()


func generate_chunk() -> void:
	for x in range(width):
		for y in range(height):
			var cell_pos = Vector2i(x, y)
			
			var noise_x = x * ratio
			var noise_y = y * ratio
			
			var moist = moisture.get_noise_2d(noise_x, noise_y)
			var temp = temperature.get_noise_2d(noise_x, noise_y)
			var alt = altitude.get_noise_2d(noise_x, noise_y)
		
			var iy = round(temp * 2 + 2)
			var ix = round(moist * 2 + 2)
			
			if alt < water_height:
				set_cell(0, cell_pos, 0, Vector2i(3, 3))
			else:
				set_cell(0, cell_pos, 0, Vector2i(ix, iy))
