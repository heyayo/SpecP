extends StaticBody2D

class_name Building;

@export_category("Configuration")
@export var structure_data : Construct;

@onready var work_target : Work_Target = $"Work Target";
@onready var sprite : Sprite2D = $Sprite2D;
@onready var collision_shape : CollisionShape2D = $CollisionShape2D;
@onready var wt_shape : CollisionShape2D = $"Work Target/CollisionShape2D";

func make(construct : Construct) -> Building:
	structure_data = construct;
	return self;

func construct() -> void:
	var size : int = structure_data.tile_size * 16;
	var rect : RectangleShape2D = collision_shape.shape;
	rect.size = Vector2(size,size);
	sprite.texture = structure_data.texture;
	wt_shape.shape.size = Vector2(size,size);
	work_target.callback = Callable(self,"interact");

func _ready():
	if (structure_data == null):
		printerr("No Structure Data | Likely unconstructed");
		queue_free();
		return;

func interact() -> void:
	print_rich("[color=blue]Empty Interaction[/color]")
