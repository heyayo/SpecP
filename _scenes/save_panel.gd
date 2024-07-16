extends ColorRect
class_name SavePanel

@onready var title = $Title
@onready var date = $Date
var data : SaveData = null;

func build(save_data : SaveData) -> void:
	data = save_data;
	title.text = "SAVE: %s" % data.name;
	date.text = data.date;

func load_save() -> void:
	LoadingScreen.scene = "res://_scenes/game.tscn"
	Game.game_save = data;
	get_tree().change_scene_to_file("res://_scenes/loading_screen.tscn");
