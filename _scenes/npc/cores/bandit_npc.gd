extends Node2D

@onready var unit : Unit = get_parent();
@onready var sight : Detection = $Sight

@export var sight_range : int = 5;

func _ready() -> void:
	if (sight_range > unit.range):
		print("Bandit Sight Range closer than Attack Range");
	sight.scale = Vector2(sight_range,sight_range);

func _process(_delta) -> void:
	attack_nearest();

func attack_nearest() -> void:
	if (sight.is_empty()): return;
	var target = sight.has_group_node(Common.group_faction_friendly);
	if (is_instance_valid(target)):
		unit.apply_target(target);
