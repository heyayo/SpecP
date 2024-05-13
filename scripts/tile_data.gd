extends Node

var _tileSet : TileSet = preload("res://tilesets/set.tres");

class TileInfo:
	var tile_name : String;
	var desc : String;
	func _init(n : String, d : String):
		tile_name = n;
		desc = d;

class Structure:
	var bname : String;
	var desc : String;
	var prefab : PackedScene;
	func _init(n : String, d : String, p : PackedScene):
		bname = n;
		desc = d;
		prefab = p;

var TILE_INFO_LOOKUP = {
	"dirt":TileInfo.new("Dirt","This is Dirt"),
	"grass":TileInfo.new("Grass","This is Grass"),
	"cobble":TileInfo.new("Cobble","A Cobblestone path"),
}

var BUILDINGS_LIST = [
	Structure.new("House", "A Basic House for 4 People", preload("res://buildings/house.tscn")),
	Structure.new("Bank", "Stores the Colony's Gold", preload("res://buildings/bank.tscn")),
];
