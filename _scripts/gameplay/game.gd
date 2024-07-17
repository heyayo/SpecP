extends Node2D

class_name Game

@onready var tilemap : TileMap = $TileMap;
@onready var resources : MResource = $Resources
@onready var game_conditions = $"Interface/Game Conditions"
@onready var game_end_title = $"Interface/Game Conditions/Game End"
@onready var game_end_timer = $"Game End Timer"
@onready var builder = $Builder
@onready var starter_bundle = $"Starter Bundle"

static var game_save_name : String = "default";
static var game_save : SaveData = null;
static var instance : Game = null;

func _init() -> void:
	instance = self;
func _ready() -> void:
	if (!is_instance_valid(game_save)): return;
	starter_bundle.queue_free();
	for r in game_save.environmental_resources:
		var wr : WorldResource = WorldResource.from_json(r);
		add_child(wr);
	for u in game_save.units:
		var unit : Unit = Unit.from_json(u);
		add_child(unit);
	for s in game_save.structures:
		var st : Structure = Structure.from_json(s);
		builder.add_child(st);
		st.finish_construction();
		if (st is ResourceStructure):
			st.sig_harvest.connect(give_resource);
	resources.wood = game_save.wood;
	resources.food = game_save.food;
	resources.stone = game_save.stone;
	resources.metal = game_save.metal;
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
	unit.add_to_group(Common.group_unit);
func spawn_friendly(unit : Unit) -> void:
	add_child(unit);
	unit.add_to_group(Common.group_friendly);
#endregion
#region Game Win/Loss
func end_game() -> void:
	game_end_title.visible = true;
	get_tree().paused = true;
	game_end_timer.start();
func _timeout_from_game_end_timer():
	print("TODO Return to main menu");
	get_tree().change_scene_to_file("res://_scenes/main_menu.tscn");
#endregion

static func get_game() -> Game:
	if (!is_instance_valid(instance)):
		printerr("GAME INSTANCE IS NOT SET DURING GAME TIME");
	return instance;
