extends Button
class_name ArchiveButton

signal sig_archive_pressed(title : String, info : String);

@export var title : String;
@export_multiline var info : String;

func _pressed() -> void:
	sig_archive_pressed.emit(title,info);
