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

@onready var builder_node : Builder = get_node("/root/World/Builder Node");

func _ready():
	input_event.connect(_on_input_event);
	print("Connected Signals");

func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		WorldStorage.unregister_structure(global_position);

func _on_input_event(viewport : Node, event : InputEvent, shape_index : int) -> void:
	if (event.is_action_pressed("Left_Click")):
		builder_node.highlight_structure(self);
