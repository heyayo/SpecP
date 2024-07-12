extends Control
class_name MainMenu

@onready var menu = $Menu
@onready var world_gen = $"World Gen"

@onready var size_options = $"World Gen/World Size/Size Options";
var world_config : WorldConfiguration = preload("res://_resources/worldconfig.tres");
var game_scene : PackedScene = preload("res://_scenes/game.tscn");
func _ready() -> void:
	get_tree().paused = false; ## Required for return trip
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
	## Load Into Main Scene
	get_tree().change_scene_to_packed(game_scene);
func _pressed_from_return():
	menu.visible = true;
	world_gen.visible = false;
