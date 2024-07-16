extends Node
class_name BaseRaider

@onready var base = get_tree().get_nodes_in_group("Base Structure").front();;
@onready var parent : Unit = get_parent();

func _ready() -> void:
	parent.behaviour = Unit.BEHAVIOUR.AGGRESSIVE;
func _process(_delta) -> void:
	if (is_instance_valid(parent.desired_target)): return;
	parent.attack_action(base);
