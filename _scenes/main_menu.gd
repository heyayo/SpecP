extends Control
class_name MainMenu

@onready var menu = $Menu
@onready var world_gen = $"World Gen"
@onready var options = $Options
@onready var saves = $"Load Saves/BG/ScrollContainer/HBoxContainer"
@onready var load_saves = $"Load Saves"
@onready var load_builder : SavePanelBuilder = $"Load Saves/BG/ScrollContainer/HBoxContainer"
@onready var save_name_input = $"World Gen/Save Name/Save Name Input"

@onready var size_options = $"World Gen/World Size/Size Options";
var world_config : WorldConfiguration = preload("res://_resources/worldconfig.tres");
var game_scene : PackedScene = preload("res://_scenes/game.tscn");
var config : GameConfiguration = preload("res://_resources/config.tres")
func _ready() -> void:
	get_tree().paused = false; ## Required for return trip
	config.load_file();
	options.sync_config();
	options.apply_config();
func _pressed_from_quit():
	get_tree().quit();
func _pressed_from_start():
	print("Pressed Start");
	menu.visible = false;
	world_gen.visible = true;
func _pressed_from_generate():
	var ws_option : int = size_options.selected;
	match (ws_option):
		0:
			world_config.world_size = Vector2i(500,500);
		1:
			world_config.world_size = Vector2i(1000,1000);
	var save_name : String = save_name_input.text;
	if (!save_name.is_empty()):
		Game.game_save_name = save_name;
	## Load Into Main Scene
	LoadingScreen.scene = game_scene.resource_path;
	get_tree().change_scene_to_file("res://_scenes/loading_screen.tscn");
func _pressed_from_return():
	menu.visible = true;
	world_gen.visible = false;
func _pressed_from_settings():
	menu.visible = false;
	world_gen.visible = false;
	options.visible = true;
	options.sync_config();
func _pressed_from_back():
	menu.visible = true;
	world_gen.visible = false;
	options.visible = false;
	options.no_save();
func _pressed_from_load():
	menu.visible = false;
	world_gen.visible = false;
	options.visible = false;
	load_saves.visible = true;
	load_builder.build_saves();
func _pressed_from_load_back():
	menu.visible = true;
	world_gen.visible = false;
	options.visible = false;
	load_saves.visible = false;
func _pressed_from_apply():
	menu.visible = true;
	world_gen.visible = false;
	options.visible = false;
	options.apply();
	options.apply_config();
