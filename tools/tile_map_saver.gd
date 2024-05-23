extends Node2D

@export var building : Construct;
@export_dir var output_dir : String;

var tilemap : TileMap;
var window : Window;
var viewport : Viewport;

func _ready():
	tilemap = $TileMap;
	if (tilemap == null):
		printerr("No TileMap");
		get_tree().quit();
		return;
	if (building == null):
		printerr("No Building");
		get_tree().quit();
		return;
	window = get_window();
	window.min_size = Vector2(16,16);
	viewport = tilemap.get_viewport();
	resize_window();

func _process(_delta):
	if (Input.is_key_pressed(KEY_SPACE)):
		save_viewport();
		get_tree().quit();

func resize_window():
	var size = building.tile_size * 16;
	window.size = Vector2(size,size);

func save_viewport():
	var image : Image = viewport.get_texture().get_image();
	image.save_png(output_dir + "/output.png");
	print("Saved Viewport to %s" % output_dir);