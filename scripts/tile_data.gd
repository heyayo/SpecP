extends Node

var _tileSet : TileSet = preload("res://tilesets/set.tres");

class TileInfo:
	var tile_name : String;
	var desc : String;
	func _init(n : String, d : String):
		tile_name = n;
		desc = d;

var TILE_INFO_LOOKUP = {
	"dirt":TileInfo.new("Dirt","This is Dirt"),
	"grass":TileInfo.new("Grass","This is Grass"),
	"cobble":TileInfo.new("Cobble","A Cobblestone path"),
}

var BUILDINGS_LIST : Array;
