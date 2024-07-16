extends Area2D
class_name WorldResource

@export var type : Common.RESOURCE_TYPE;

func _ready() -> void:
	add_to_group(Common.group_persist);

func save() -> Dictionary:
	var data : Dictionary = {
		"x":global_position.x,
		"y":global_position.y,
		"type":type,
		"res":scene_file_path
	}
	return data;
static func from_json(data : Dictionary) -> WorldResource:
	var scene = load(data["res"]);
	var r : WorldResource = scene.instantiate();
	r.global_position = Vector2(data["x"], data["y"]);
	r.type = data["type"];
	return r;
