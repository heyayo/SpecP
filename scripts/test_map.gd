extends TileMap

var world_tileset : TileSet;
var tile_dirt = Vector2i(0,1);

# Called when the node enters the scene tree for the first time.
func _ready():
	world_tileset = load("res://tilesets/test_map.tres");
	generate_world();

func _process(delta):
	pass

func generate_world():
	for i in range(10):
		var tile_pos = Vector2i(i,0);
		print("Placing Tile on " + str(tile_pos));
		set_cell(0,tile_pos,0, tile_dirt);
