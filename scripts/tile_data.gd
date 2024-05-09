extends Node

var _tileSet : TileSet = preload("res://tilesets/set.tres");

class TileInfo:
	var tile_name : String;
	var desc : String;
	func _init(n : String, d : String):
		tile_name = n;
		desc = d;
		pass

class Structure:
	var bname : String;
	var pattern : TileMapPattern;
	var cost : int;
	var build_time : float;
	func _init(n : String, p : TileMapPattern, c : int, t : float):
		bname = n;
		pattern = p;
		cost = c;
		build_time = t;
		pass

var TILE_INFO_LOOKUP = {
	"dirt":TileInfo.new("Dirt","This is Dirt"),
	"grass":TileInfo.new("Grass","This is Grass"),
	"cobble":TileInfo.new("Cobble","A Cobblestone path"),
}

var BUILDINGS_LIST = [
	Structure.new("Room",_tileSet.get_pattern(0),10,5),
];
