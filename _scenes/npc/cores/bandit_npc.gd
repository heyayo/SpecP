extends Node2D
class_name HostileNPC
#region Modules
@onready var unit = get_parent();
@onready var sight : Detection = $Sight
#endregion
@export var stats : HostileStats;

func _ready() -> void:
	unit.behaviour = Unit.BEHAVIOUR.AGGRESSIVE;
#func _process(_delta) -> void:
	#if (sight.is_empty()):
		#return;
	#var target = sight.has_group_node(Common.group_friendly);
	#if (is_instance_valid(target)):
		#unit.attack_action(target);
