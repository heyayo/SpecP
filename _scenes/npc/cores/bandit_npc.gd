extends Node2D
class_name HostileNPC
#region Modules
@onready var unit = get_parent();
@onready var sight : Detection = $Sight
#endregion
@export var stats : HostileStats;

func _ready() -> void:
	sight.scale = stats.npcaggro();
	unit.behaviour = UnitRewrite.BEHAVIOUR.PASSIVE;
func _process(_delta) -> void:
	attack_nearest();
func attack_nearest() -> void:
	if (sight.is_empty()): return;
	var target = sight.has_group_node(Common.group_friendly);
	if (is_instance_valid(target)):
		unit.attack_action(target);
