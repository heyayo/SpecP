extends Node2D

class_name Game

@onready var tilemap : TileMap = $TileMap;
@onready var actioner : Actioner = $Actioner;

const tile_size = 16;
func get_hover_position() -> Vector2i:
	var tilemap_position : Vector2i = get_tilemap_position();
	var hover_position = tilemap_position * tile_size;
	return hover_position + Vector2i(8,8);
func get_tilemap_position() -> Vector2i:
	var mouse_position : Vector2 = get_global_mouse_position();
	var tilemap_position : Vector2i = tilemap.local_to_map(mouse_position);
	return tilemap_position;
