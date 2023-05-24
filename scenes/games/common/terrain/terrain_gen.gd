@tool
extends MeshInstance3D

@export_category("Mesh Settings")
@export var xSize: int = 20
@export var zSize: int = 20

@export_range(0.0, 1.0) var water_level: float = 0.5
@export var height_max: float = 10.0

@export var update:bool = false
@export var clear_vert_vis: bool = false

@export_category("Terrain Noise")
@export var fractal_gain: float = 0.5
@export var fractal_lacunarity: float = 2.0
@export var fractal_ping_pong_strength: float = 2.0
@export var fractal_octaves: int = 5
@export_enum("None:0", "FBM:1", "Ridged:2", "Ping Pong:3") var fractal_type = 1 
@export var frequency: float = 0.01
@export_enum("Simplex:0", "Simplex Smooth:1", "Cellular:2", "Perlin:3", "Value Cubic:4", "Value:5") var noise_type = 0

var terrain_noise:FastNoiseLite


func _ready():
	generate_terrain()

func generate_terrain() -> void:
	var a_mesh: ArrayMesh
	var surface_tool = SurfaceTool.new()
	init_terrain_noise()
	
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for z in range(zSize + 1):
		for x in range(xSize + 1):
			var y = get_terrain_height(x, z)
			surface_tool.add_vertex(Vector3(x, y, z))
	
	var vert = 0
	for z in range(zSize):
		for x in range(xSize):
			surface_tool.add_index(vert + 0)
			surface_tool.add_index(vert + 1)
			surface_tool.add_index(vert + xSize + 1)
			
			surface_tool.add_index(vert + xSize + 1)
			surface_tool.add_index(vert + 1)
			surface_tool.add_index(vert + xSize + 2)
			vert += 1
		vert += 1

	surface_tool.generate_normals()
	a_mesh = surface_tool.commit()
	mesh = a_mesh
	
func init_terrain_noise() -> void:
	terrain_noise = FastNoiseLite.new()
	terrain_noise.seed = randi()
	terrain_noise.fractal_gain = fractal_gain
	terrain_noise.fractal_lacunarity = fractal_lacunarity
	terrain_noise.fractal_ping_pong_strength = fractal_ping_pong_strength
	terrain_noise.fractal_octaves = fractal_octaves
	terrain_noise.fractal_type = fractal_type as FastNoiseLite.FractalType
	terrain_noise.frequency = frequency
	terrain_noise.noise_type = noise_type as FastNoiseLite.NoiseType
	

func get_terrain_height(x, z) -> float:
	var height: float = (terrain_noise.get_noise_2d(x, z) + 1.0) / 2.0
	height = height * height - water_level
	
	if height < 0:
		height = 0
	
	return height * height_max

func _process(_delta):
	if update:
		generate_terrain()
		update = false
		
	if clear_vert_vis:
		for i in get_children():
			i.free()
		clear_vert_vis = false
