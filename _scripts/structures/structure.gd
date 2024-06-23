extends Area2D
class_name Structure

@export var data : StructureData;

func _ready() -> void:
	set_collision_layer_value(Common.layer_structure,true);
	print("%s | Initializing Structure" % name);

func finish_construction() -> void:
	print("%s | Constructed" % name);
