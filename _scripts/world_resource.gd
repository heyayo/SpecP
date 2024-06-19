extends Area2D

class_name WorldResource

@export_category("Configuration")
@export var drop_type : Common.RESOURCE_TYPE;
@export var drop_amount : int = 1;
@export var object_data : WorldObject;

@export_category("Status")
@export var harvest_health_max = 1;
@export var harvest_health = 0;

@onready var game : Game = get_tree().root.get_node("Game");

func _ready() -> void:
	set_collision_layer_value(Common.layer_resource,true);
	add_to_group(Common.group_resource);
	print("%s | Initializing World Resource" % name);

# TODO Remove LEGACY
func harvest(efficiency : int) -> void:
	harvest_health += efficiency;
	if (harvest_health >= harvest_health_max):
		game.give_resource(drop_type,drop_amount);
		queue_free();
