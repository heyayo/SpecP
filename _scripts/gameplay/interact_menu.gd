extends Control

class_name InteractMenu

@onready var structure_actions : ColorRect = $"Structure Actions"
@onready var harvest_actions : ColorRect = $"Harvest Actions"

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
			continue;
		if (o is WorldResource):
			harvest_actions.visible = true;
			continue;

#region BACKUP
#@onready var multiple_selection : Control = $"Multiple Selection"
##region Filters
#@onready var filter_structures : Button = $"Multiple Selection/Filter Buttons/Filter Structures"
#@onready var filter_harvestables : Button = $"Multiple Selection/Filter Buttons/Filter Harvestables"
#@onready var filter_colonists : Button = $"Multiple Selection/Filter Buttons/Filter Colonists"
##endregion
##region Action Containers
#@onready var structure_actions : Button = $"Single Selection/Actions/Structure Actions"
#@onready var harvestable_actions : Button = $"Single Selection/Actions/Harvestable Actions"
##endregion
#
#func _sig_select_from_selector(selection : Array):
	#var multiple : bool = determine_multiple(selection);
	#multiple_selection.visible = multiple;
#
#func determine_multiple(selection : Array) -> bool:
	#var types : int = 0;
	#for n in selection:
		#if (n is Structure and not filter_structures.visible):
			#filter_structures.visible = true;
			#types += 1;
			#continue;
		#if (n is WorldResource and not filter_harvestables.visible):
			#filter_harvestables.visible = true;
			#types += 1;
			#continue;
		## TODO Filter Colonists
	#return types > 1;
#
#func _pressed_from_filter_structures():
	#structure_actions.visible = true;
#func _pressed_from_filter_harvestables():
	#harvestable_actions.visible = true;
#endregion
