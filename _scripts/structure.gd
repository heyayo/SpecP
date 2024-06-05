extends Node2D

class_name Structure

var data : Construct = null;

@onready var collision_shape : CollisionShape2D = $CollisionShape2D;
@onready var sprite = $Sprite2D

func _ready() -> void:
	var shape : RectangleShape2D = collision_shape.shape;
	var resize = 16 * data.tile_size;
	resize -= 1;
	shape.size = Vector2(resize,resize);
	sprite.texture = data.sprite;
	# Clear all Groups
	var groups : Array[StringName] = get_groups();
	for group in groups:
		remove_from_group(group);

func make(blueprint : Construct) -> Structure:
	data = blueprint;
	if (data == null):
		printerr("Structure has no blueprints");
	return self;

func construct() -> void:
	add_to_group(Common.group_structures);

func deconstruct() -> void:
	remove_from_group(Common.group_structures);
	queue_free();

func get_construcion_mark() -> ConstructionMark:
	return get_node("Construction Mark");
