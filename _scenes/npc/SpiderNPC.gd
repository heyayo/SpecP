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
func _input(event) -> void:
	if (Input.is_key_pressed(KEY_P)):
		unit.behaviour = Unit.BEHAVIOUR.PASSIVE;
	if (Input.is_key_pressed(KEY_O)):
		unit.behaviour = Unit.BEHAVIOUR.DEFENSIVE;
	if (Input.is_key_pressed(KEY_I)):
		unit.behaviour = Unit.BEHAVIOUR.AGGRESSIVE;
#func _process(_delta) -> void:
	#if (range.is_empty()): return;
	#var target : Unit = range.has_group_node(Common.group_friendly);
	#if (!is_instance_valid(target)): return;
	#unit.attack_action_stay(target);
