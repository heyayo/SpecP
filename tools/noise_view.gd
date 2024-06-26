@tool
extends EditorScript
class_name NoisePreview

var save : String = "res://tools/output/";
var world_config : WorldConfiguration = preload("res://_resources/worldconfig.tres");
var scale : float = 0.75;
var stone_scale : float = 3;
var rise : float = 0.5;
var tree_thresh : float = 0.65;
var stone_thresh : float = 0.7;

var thread : Thread;

func _run() -> void:
	print("Begin World Gen");
	thread = Thread.new();
	thread.start(generate_image);
	thread.wait_to_finish();
	get_editor_interface().get_resource_filesystem().scan_sources();

func generate_image() -> void:
	var tree_noise : FastNoiseLite = FastNoiseLite.new();
	tree_noise.noise_type = FastNoiseLite.TYPE_PERLIN;
	tree_noise.seed = randi();
	var stone_noise : FastNoiseLite = tree_noise.duplicate();
	stone_noise.seed = randi();
	
	var size : Vector2i = world_config.world_size;
	var image : Image = Image.create(size.x,size.y,false,Image.FORMAT_RGB8);
	image.fill(Color.BLACK);
	var pressed_image : Image = image.duplicate();
	var red_only : Image = image.duplicate();
	var green_only : Image = image.duplicate();
	for x in size.x:
		for y in size.y:
			var sx : float = x * scale;
			var sy : float = y * scale;
			var tree_value : float = tree_noise.get_noise_2d(sx,sy) + rise;
			var stone_value : float = stone_noise.get_noise_2d(sx * stone_scale,sy * stone_scale) + rise;
			var rsnap : int = snap(stone_value,stone_thresh) * 255;
			var gsnap : int = snap(tree_value,tree_thresh) * 255;
			image.set_pixel(x,y,Color(stone_value,tree_value,0));
			pressed_image.set_pixel(x,y,Color(rsnap,gsnap,0));
			red_only.set_pixel(x,y,Color(rsnap,0,0));
			green_only.set_pixel(x,y,Color(0,gsnap,0));
	image.save_jpg(save + "world.jpg");
	pressed_image.save_jpg(save + "pressed.jpg");
	red_only.save_jpg(save + "ronly.jpg");
	green_only.save_jpg(save + "gonly.jpg");
	print("Saved World Image");
func snap(value : float, threshold : float) -> float:
	#if (value > 1 or value < 0): print("Value is outside of float range 0-1 | VALUE: %s" % value);
	if (value >= threshold): return 1;
	return 0;
