extends VBoxContainer
class_name AudioSliders

var audio_bus : AudioBusLayout = preload("res://default_bus_layout.tres");

@onready var master_bus : int = AudioServer.get_bus_index("Master");
@onready var music_bus : int = AudioServer.get_bus_index("Music");
@onready var sfx_bus : int = AudioServer.get_bus_index("Sound Effects")
@onready var master_slider = $"Master Slider"
@onready var music_slider = $"Music Slider"
@onready var sfx_slider = $"SFX Slider"

func _ready() -> void:
	sync_bus();
func _value_changed_from_master_slider(value):
	AudioServer.set_bus_volume_db(master_bus,log(value)*20);
func _value_changed_from_music_slider(value):
	AudioServer.set_bus_volume_db(music_bus,log(value)*20);
func _value_changed_from_sfx_slider(value):
	AudioServer.set_bus_volume_db(sfx_bus,log(value)*20);
func sync_sliders() -> void:
	master_slider.value = bus_to_slider_value(master_bus);
	music_slider.value = bus_to_slider_value(music_bus);
	sfx_slider.value = bus_to_slider_value(sfx_bus);
func sync_bus() -> void:
	AudioServer.set_bus_volume_db(master_bus,log(master_slider.value)*20);
	AudioServer.set_bus_volume_db(music_bus,log(music_slider.value)*20);
	AudioServer.set_bus_volume_db(sfx_bus,log(sfx_slider.value)*20);

func bus_to_slider_value(bus : int) -> float:
	var bus_value : float = AudioServer.get_bus_volume_db(bus);
	return pow(bus_value/20,10);
