extends StaticBody2D

class_name Structure

# TODO Structure Class
@export var object_data : WorldObject;
@export var work_cost : int = 10;
@export var wood : int;
@export var food : int;
@export var stone : int;

func _ready() -> void:
	set_collision_layer_value(Common.layer_structure,true);
	add_to_group(Common.group_structure);
	print("%s | Initializing Structure" % name);

func finish_construction() -> void:
	print("%s | Constructed" % name);
