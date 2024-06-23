extends Control

class_name InteractMenu

@onready var structure_actions : ColorRect = $"Structure Actions"
@onready var harvest_actions : ColorRect = $"Harvest Actions" ## Deprecated

func _ready() -> void:
	hide_actions();

func hide_actions() -> void:
	structure_actions.visible = false;
	harvest_actions.visible = false;
func show_actions(selection : Array) -> void:
	hide_actions();
	for n in selection:
		var o = n.get_parent();
		if (o is Structure):
			structure_actions.visible = true;
			break;
