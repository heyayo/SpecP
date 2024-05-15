extends Node

var group_construction : String = "In_Construction";
var group_housing : String = "Housing";

var cLayer_buildings : int = 0b00000000_00000000_00000000_00000001;

func tile_to_hover(tile_position : Vector2i) -> Vector2i:
	tile_position *= 16;
	tile_position += Vector2i(8,8);
	return tile_position;
