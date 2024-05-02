extends Node

class TileInfo:
	var tile_name : String;
	var desc : String;
	func _init(n : String, d : String):
		tile_name = n;
		desc = d;
		pass

var TILE_INFO_LOOKUP = {
	"dirt":TileInfo.new("Dirt","This is dirt"),
	"grass":TileInfo.new("Grass","This is grass")
}
