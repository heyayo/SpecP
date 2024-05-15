extends StaticBody2D

class_name Building;

@export_category("Costs")
@export var cost_wood : int;
@export var cost_metal : int;
@export var cost_food : int;
@export var cost_gold : int;
@export var time : float;

@export_category("Selection Properties")
@export var tile_size : int;

func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		WorldStorage.unregister_structure(global_position);
