extends Control

class_name InteractMenu

@onready var structure_actions : ColorRect = $"Structure Actions"
@onready var behaviour = $"Unit Info/Behaviour"

func _ready() -> void:
	hide_actions();

func hide_actions() -> void:
	structure_actions.visible = false;
func show_actions(selection : Array) -> void:
	hide_actions();
	for n in selection:
		var o = n.get_parent();
		if (o is Structure):
			structure_actions.visible = true;
			break;
func show_unit_info(units : Array) -> void:
	if (units.is_empty()): return;
	if (units.size() > 1):
		var check : Dictionary = {};
		for u in units:
			if (!is_instance_valid(u)): continue;
			match (u.behaviour):
				Unit.BEHAVIOUR.PASSIVE:
					check["P"] = 0;
				Unit.BEHAVIOUR.DEFENSIVE:
					check["D"] = 0;
				Unit.BEHAVIOUR.AGGRESSIVE:
					check["A"] = 0;
		if (check.size() > 1):
			behaviour.text = "Behaviour: [MIXED]";
			return;
	var unit : Unit = units.front();
	if (!is_instance_valid(unit)): return;
	match (unit.behaviour):
		Unit.BEHAVIOUR.PASSIVE:
			behaviour.text = "Behaviour: Passive";
		Unit.BEHAVIOUR.DEFENSIVE:
			behaviour.text = "Behaviour: Defensive";
		Unit.BEHAVIOUR.AGGRESSIVE:
			behaviour.text = "Behaviour: Aggressive";
