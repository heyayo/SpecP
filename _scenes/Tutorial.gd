extends CanvasLayer
class_name Tutorial

signal sig_on_open;

@onready var helpers = $Helpers

@onready var info_dump = $"Helpers/BG/Info Dump"
@onready var archive = $Helpers/BG/Archive
@onready var dump_title : Label = $"Helpers/BG/Info Dump/Title"
@onready var dump_info = $"Helpers/BG/Info Dump/Info Scroll/Info"

func _ready() -> void:
	helpers.visible = true;
	archive.visible = true;
	info_dump.visible = false;
	dump_title.text = "";
	dump_info.text = "";
func _process(_delta) -> void:
	if (Input.is_action_just_pressed("helper")):
		helpers.visible = !helpers.visible;
		sig_on_open.emit();

#region Signal Callbacks
func _pressed_from_info_back():
	info_dump.visible = false;
	archive.visible = true;
func _pressed_from_archive(title : String, info : String) -> void:
	archive.visible = false;
	info_dump.visible = true;
	dump_title.text = title;
	dump_info.text = info;
#endregion
