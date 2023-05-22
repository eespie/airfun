extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 256
var height = 256

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.005
	generate_chunk(Vector2i(0, 0))


func generate_chunk(pos):
	var tile_pos = local_to_map(pos)
	var w2 = 0
	var h2 = 0
	for x in range(width):
		for y in range(height):
			var cell_pos = Vector2i(tile_pos.x-w2 + x, tile_pos.y-h2 + y)
			if get_cell_source_id(0, cell_pos) == -1:
				var moist = moisture.get_noise_2d(tile_pos.x-w2 + x, tile_pos.y-h2 + y)*10
				var temp = temperature.get_noise_2d(tile_pos.x-w2 + x, tile_pos.y-h2 + y)*10
				var alt = altitude.get_noise_2d(tile_pos.x-w2 + x, tile_pos.y-h2 + y)*10
			
				if alt < -5:
					set_cell(0, cell_pos, 0, Vector2(3, round((temp+10)/5)))
				else:
					set_cell(0, cell_pos, 0, Vector2(round((moist+10)/5), round((temp+10)/5)))
