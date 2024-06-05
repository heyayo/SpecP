extends StaticBody2D

class_name Harvestable

signal sig_harvest(harvest : Harvestable);

var item_prefab : PackedScene = preload("res://_scenes/prefabs/resource_item.tscn");

@export var data : HarvestableData;

@onready var collision : CollisionShape2D = $CollisionShape2D;
@onready var sprite : Sprite2D = $Sprite2D;

var health : int = 0;

func make(blueprint : HarvestableData) -> Harvestable:
	data = blueprint;
	return self;

func _ready() -> void:
	sprite.texture = data.sprite;
	var shape : RectangleShape2D = collision.shape;
	shape.size = data.size * 16 - Vector2i(1,1);
	health = data.resource_health;

func tick_harvest(efficiency : int) -> void:
	health -= efficiency;
	if (health <= 0):
		harvest();
func harvest() -> void:
	for drop in data.drops:
		var d : ResourceItem = item_prefab.instantiate().make(drop.resource);
		get_tree().root.add_child(d);
		d.global_position = global_position;
		d.stack = drop.amount;
	sig_harvest.emit(self);
