extends TileMap

@export var ratio: float
@export var water_height: float

var altitude = FastNoiseLite.new()
var width = 256
var height = 256

const d_pos = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]


func _ready() -> void:
	altitude.seed = randi()
	altitude.frequency = 0.05
	#altitude.fractal_type = FastNoiseLite.FRACTAL_RIDGED
	generate_chunk()


func generate_chunk() -> void:
	for x in range(width):
		for y in range(height):
			var cell_pos = Vector2i(x, y)
			var alt = altitude.get_noise_2d(x * ratio, y * ratio)
			alt = (alt + 1.0) / 2.0
			if alt > water_height:
				alt = 1
			else:
				alt = 0
			
			var possibilities = [0]
			
			for dp in range(4):
				var source = cell_pos + d_pos[dp]
				var atlas_cell = get_cell_atlas_coords(0, source)
				var id_cell
				var increment = pow(2, 3 - dp) as int
				var value_edge = 1
				if atlas_cell.x == -1:
					id_cell = -1
				else:
					id_cell = 4 * atlas_cell.x + atlas_cell.y
					value_edge = id_cell & increment

				var offset = possibilities.size()
				if id_cell == -1:
					possibilities.resize(offset * 2)
					for p in range(offset):
						possibilities[p + offset] = possibilities[p]
				if value_edge != 0:
					for p in range(offset):
						possibilities[p] = possibilities[p] + increment
			
			possibilities.sort()
			var new_id = possibilities[floor(alt * (possibilities.size() - 1))] as int
			var ix = new_id % 4
			var iy = floor(new_id / 4.0)
			#print(str(x, " - ", y, " - ", new_id, " : ", ix, " ", iy, "  - ", alt))
			set_cell(0, cell_pos, 0, Vector2i(ix, iy))
