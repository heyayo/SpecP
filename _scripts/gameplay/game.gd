extends Node2D

class_name Game

@onready var tilemap : TileMap = $TileMap;
@onready var resources : MResource = $Resources

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
		Common.RESOURCE_TYPE.METAL:
			resources.metal += amount;
func deduct_resource(type : Common.RESOURCE_TYPE, amount : int) -> void:
	match (type):
		Common.RESOURCE_TYPE.WOOD:
			resources.wood -= amount;
		Common.RESOURCE_TYPE.FOOD:
			resources.food -= amount;
		Common.RESOURCE_TYPE.STONE:
			resources.stone -= amount;
		Common.RESOURCE_TYPE.METAL:
			resources.metal -= amount;
func adjust_resources(wood : int, food : int, stone : int, metal : int) -> void:
	resources.wood += wood;
	resources.food += food;
	resources.stone += stone;
	resources.metal += metal;
func adjust_structure_cost(cost : StructureData) -> void:
	resources.wood -= cost.wood;
	resources.food -= cost.food;
	resources.stone -= cost.stone;
	resources.metal -= cost.metal;
#endregion
#region Units
func spawn_unit(unit : Unit) -> void:
	add_child(unit);
func spawn_friendly(unit : Unit) -> void:
	add_child(unit);
#endregion
