extends Control

class_name Info_Panel;

@onready var _nameLabel : Label = $"ColorRect/Tile Name";
@onready var _descLabel : Label = $"ColorRect/Tile Description";

func display_tile(data : TileData) -> void:
	# FIXME REDO
	#var cd_name = data.get_custom_data("names"); # Feadwtch Name Custom Data
	## Check if the tile has been registered
	#var info : Tile_Database.TileInfo;
	#if (Tile_Database.TILE_INFO_LOOKUP.has(cd_name)):
		#info = Tile_Database.TILE_INFO_LOOKUP[cd_name];
		#pass
	#else:
		#info = Tile_Database.TileInfo.new("UNKNOWN", "UNKNOWN TILE");
		#pass
	#
	## Set Info Panel
	#_nameLabel.text = info.tile_name;
	#_descLabel.text = info.desc;
	#visible = true;
	pass
