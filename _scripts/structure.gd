extends Node2D

class_name Structure

var data : Construct = null;

@onready var collision_shape : CollisionShape2D = $CollisionShape2D;
@onready var sprite = $Sprite2D

func make(blueprint : Construct) -> void:
	data = blueprint;
	if (data == null):
		printerr("Structure has no blueprints");
		return;
	var shape : RectangleShape2D = collision_shape.shape;
	shape.size = Vector2(data.tile_size,data.tile_size);
	sprite.texture = data.sprite;
	# Clear all Groups
	var groups : Array[StringName] = get_groups();
	for group in groups:
		remove_from_group(group);

func construct() -> void:
	add_to_group(Common.group_structures);

func deconstruct() -> void:
	remove_from_group(Common.group_structures);
