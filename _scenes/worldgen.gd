extends TileMap
class_name WorldGen

@export var config : WorldConfiguration;

#region Constants
const rise : float = 1;
const forest_scale : float = 0.75;
const forest_threshold : float = 0.65;
const mountain_scale : float = 3;
const mountain_threshold : float = 0.7;
const spawn_radius : int = 16;
#endregion
var forest_noise : FastNoiseLite;
var mountain_noise : FastNoiseLite;
#region Atlas Coordinates
const grass_1 := Vector2i(5,0);
const grass_2 := Vector2i(5,1);
const grass_3 := Vector2i(5,2);
const grasses = [grass_1,grass_2,grass_3];
#endregion
#region Assets
const tree_pack : PackedScene = preload("res://_scenes/prefabs/resources/tree.tscn");
const stone_pack : PackedScene = preload("res://_scenes/prefabs/resources/stone.tscn");
#endregion
var stone_patches : Array[Vector2i];
#region Statistic
var tree_count : int = 0;
var stone_count : int = 0;
#endregion

func _ready() -> void:
	forest_noise = FastNoiseLite.new();
	forest_noise.noise_type = FastNoiseLite.TYPE_PERLIN;
	forest_noise.seed = randi();
	mountain_noise = forest_noise.duplicate();
	mountain_noise.seed = randi();
	generate_world();
func generate_world() -> void:
	var halfx = config.world_size.x / 2;
	var halfy = config.world_size.y / 2;
	for x in range(-halfx,halfx):
		for y in range(-halfy,halfy):
			generate_tile(x,y);
			if (
				x > -spawn_radius and x < spawn_radius
				and
				y > -spawn_radius and y < spawn_radius
				): continue;
			generate_resource(x,y);
	print("Statistics | Trees: %s | Stones: %s | Stone Patch Area: %s" % [tree_count,stone_count,stone_patches.size()]);
func generate_tile(x : int, y : int) -> void:
	set_cell(0,Vector2i(x,y),1,grasses[randi_range(0,2)]);
func generate_resource(x : int, y : int) -> void:
	var real_pos : Vector2 = real_position(x,y);
	var tx : float = x * forest_scale;
	var ty : float = y * forest_scale;
	var sx : float = x * mountain_scale;
	var sy : float = y * mountain_scale;
	var forest_value : float = forest_noise.get_noise_2d(tx,ty) + rise;
	forest_value = snap(forest_value,forest_threshold);
	var mountain_value : float = mountain_noise.get_noise_2d(sx,sy) + rise;
	mountain_value = snap(mountain_value,mountain_threshold);
	if (forest_value > 0 and mountain_value > 0):
		stone_patches.push_back(Vector2i(x,y));
		return;
	if (forest_value > 0):
		tree_count += 1;
		spawn(real_pos,tree_pack);
		return;
	if (mountain_value > 0):
		stone_count += 1;
		spawn(real_pos,stone_pack);
		return;
func snap(value : float, threshold : float) -> float:
	if (value >= threshold): return 1;
	return 0;
func real_position(x : int, y : int) -> Vector2:
	return Vector2(
		x * 16,
		y * 16
		);
func spawn(pos : Vector2, object : PackedScene) -> void:
	var inst = object.instantiate();
	add_sibling.call_deferred(inst);
	inst.global_position = pos;
