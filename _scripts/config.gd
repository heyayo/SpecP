extends Resource
class_name GameConfiguration

enum WINDOW_MODE
{
	FULLSCREEN,
	WINDOWED,
	BORDERLESS
}

@export var window_mode : WINDOW_MODE = WINDOW_MODE.WINDOWED;
@export var master_volume : float = 1;
@export var music_volume : float = 1;
@export var sfx_volume : float = 1;

func save_file() -> void:
	var data : ConfigFile = ConfigFile.new();
	data.set_value("window","window mode",window_mode);
	data.set_value("volume","master",master_volume);
	data.set_value("volume","music",music_volume);
	data.set_value("volume","sfx",sfx_volume);
	data.save("user://config.cfg");
func load_file() -> void:
	var data : ConfigFile = ConfigFile.new();
	data.load("user://config.cfg");
	window_mode = data.get_value("window","window mode",WINDOW_MODE.WINDOWED);
	master_volume = data.get_value("volume","master",1);
	music_volume = data.get_value("volume","music",1);
	sfx_volume = data.get_value("volume","sfx",1);
