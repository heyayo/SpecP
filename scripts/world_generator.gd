extends TileMap

@export_category("Configuration")
@export var world_size : Vector2i = Vector2i(10,10);
@export var noise_scaling : float = 5;
@export var sea_level : float = -0.5;
@export var regen : bool:
	set(value):
		regenerate_world();

var world_tileset : TileSet;
var tile_dirt = Vector2(0,1);
var tile_water = Vector2(4,10);

func _ready():
	world_tileset = load("res://tilesets/test_map.tres");
	generate_world();

func generate_world():
	var noise_gen = FastNoiseLite.new();
	#noise_gen.seed = randi();
	noise_gen.seed = 1;
	noise_gen.noise_type = FastNoiseLite.TYPE_PERLIN;
	
	#print("Sea Level: " + str(sea_level));
	var world_x_half = world_size.x/2;
	var world_y_half = world_size.y/2;
	for x in range(-world_x_half, world_x_half):
		for y in range(-world_y_half,world_y_half):
			var noise_value = noise_gen.get_noise_2d(x / noise_scaling,y / noise_scaling);
			var tile_pos = Vector2i(x,y);
			
			if (noise_value > sea_level):
				set_cell(0,tile_pos,0,tile_dirt);
			else:
				set_cell(0,tile_pos,0,tile_water);
			pass
	pass

func clear_all():
	for x in range(world_size.x):
		for y in range(world_size.y):
			set_cell(0,Vector2i(x,y));
			pass

func regenerate_world():
	print("Regenerating World");
	clear_all();
	generate_world();
