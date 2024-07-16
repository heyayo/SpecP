extends CanvasLayer
class_name Options

@onready var audio = $Control/BG/Sections/HBoxContainer/Audio
@onready var graphics = $Control/BG/Sections/HBoxContainer/Graphics

var config : GameConfiguration = preload("res://_resources/config.tres");

func apply() -> void:
	config.master_volume = audio.master_slider.value;
	config.music_volume = audio.music_slider.value;
	config.sfx_volume = audio.sfx_slider.value;
	config.window_mode = graphics.option_button.selected
	config.save_file();

func apply_config() -> void:
	graphics.set_window_mode(config.window_mode);
	audio.sync_bus();

func apply_settings() -> void:
	apply();
	apply_config();
func no_save() -> void:
	sync_config();
	apply_config();

func sync_config() -> void:
	audio.master_slider.value = config.master_volume;
	audio.music_slider.value = config.music_volume;
	audio.sfx_slider.value = config.sfx_volume;
	graphics.option_button.selected = config.window_mode;
