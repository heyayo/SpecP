extends TileMap

class_name WORLD_MAP;

@export_category("Configuration")
@export var world_size : Vector2i = Vector2i(10,10);
@export var noise_scaling : float = 5;
@export var sea_level : float = -0.5;
@export var regen : bool:
	set(value):
		regenerate_world();

@onready var world_tileset : TileSet = preload('res://tilesets/set.tres');
var tile_grass = Vector2(1,0);

# Tilemap Layers
enum Layers {
	Ground,
	Foliage,
	Structure
}

func _ready():
	generate_world();

func generate_world():
	var noise_gen = FastNoiseLite.new();
	#noise_gen.seed = randi();
	noise_gen.seed = 1;
	noise_gen.noise_type = FastNoiseLite.TYPE_PERLIN;
	
	# TODO World Generation
	var world_x_half = world_size.x/2;
	var world_y_half = world_size.y/2;
	for x in range(-world_x_half, world_x_half):
		for y in range(-world_y_half,world_y_half):
			#var noise_value = noise_gen.get_noise_2d(x / noise_scaling,y / noise_scaling);
			var tile_pos = Vector2i(x,y);
			
			set_cell(Layers.Ground,tile_pos,0,grass_patches(0));

# TODO Redo Grass Patches Generation
func grass_patches(level : float) -> Vector2:
	return tile_grass;
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
