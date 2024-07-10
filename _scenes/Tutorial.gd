extends CanvasLayer
class_name Tutorial

@onready var helpers = $Helpers

@onready var info_dump = $"Helpers/BG/Info Dump"
@onready var archive = $Helpers/BG/Archive
@onready var dump_title : Label = $"Helpers/BG/Info Dump/Title"
@onready var dump_info = $"Helpers/BG/Info Dump/Info Scroll/Info"

func _ready() -> void:
	helpers.visible = false;
	archive.visible = true;
	info_dump.visible = false;
	dump_title.text = "";
	dump_info.text = "";
func _process(_delta) -> void:
	if (Input.is_action_just_pressed("helper")):
		helpers.visible = !helpers.visible;

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
