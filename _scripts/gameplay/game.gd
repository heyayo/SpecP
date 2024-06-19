extends Node2D

class_name Game

@onready var tilemap : TileMap = $TileMap;
@onready var resources : MResource = $Resources
@onready var overseer : Overseer = $Overseer

const tile_size = 16;
func get_hover_position() -> Vector2i:
	var tilemap_position : Vector2i = get_tilemap_position();
	var hover_position = tilemap_position * tile_size;
	return hover_position + Vector2i(8,8);
func get_tilemap_position() -> Vector2i:
	var mouse_position : Vector2 = get_global_mouse_position();
	var tilemap_position : Vector2i = tilemap.local_to_map(mouse_position);
	return tilemap_position;
#region Resources
func give_resource(type : Common.RESOURCE_TYPE, amount : int) -> void:
	match (type):
		Common.RESOURCE_TYPE.WOOD:
			resources.wood += amount;
		Common.RESOURCE_TYPE.FOOD:
			resources.food += amount;
		Common.RESOURCE_TYPE.STONE:
			resources.stone += amount;
func deduct_resource(type : Common.RESOURCE_TYPE, amount : int) -> void:
	match (type):
		Common.RESOURCE_TYPE.WOOD:
			resources.wood -= amount;
		Common.RESOURCE_TYPE.FOOD:
			resources.food -= amount;
		Common.RESOURCE_TYPE.STONE:
			resources.stone -= amount;
func adjust_resources(wood : int, food : int, stone : int) -> void:
	resources.wood += wood;
	resources.food += food;
	resources.stone += stone;
#endregion
#region Units
func spawn_unit(unit : Unit) -> void:
	overseer.add_child(unit);
#endregion
