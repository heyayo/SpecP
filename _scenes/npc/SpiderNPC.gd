extends Node2D
class_name SpiderNPC

@onready var walk_area = $"../Walk Area"
@onready var attack_area = $"../Attack Area"
@onready var range = $Range
@onready var unit : Unit = get_parent();

const spider_range : int = 40;

func _ready() -> void:
	range.scale = Vector2(spider_range,spider_range);
	unit.behaviour = Unit.BEHAVIOUR.DEFENSIVE;
