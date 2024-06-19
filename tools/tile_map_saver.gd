extends Node2D

@export var tile_size : Vector2i;
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
	window = get_window();
	window.min_size = Vector2(15,15);
	viewport = tilemap.get_viewport();
	window.borderless = true;
	resize_window();
	#window.size = Vector2i(100,100);

func _process(_delta):
	if (Input.is_key_pressed(KEY_SPACE)):
		save_viewport();
		get_tree().quit();

func resize_window():
	var size = tile_size * 16;
	window.size = size;
	print("Resizing: %s | %s" % [tile_size, size]);

func save_viewport():
	var image : Image = viewport.get_texture().get_image();
	image.save_png(output_dir + "/output.png");
	print("Saved Viewport to %s" % output_dir);
