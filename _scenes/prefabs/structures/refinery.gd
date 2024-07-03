extends Node
class_name Refinery

@onready var resources : MResource = $"/root/Game/Resources"; ## Hard Coded Path to resources
@onready var game : Game = $"/root/Game";

@export var refinery_source : Common.RESOURCE_TYPE;
@export var refinery_output : Common.RESOURCE_TYPE;
@export var efficiency_ratio : int = 1; ## How much source material to create one output material

func _ready():
	if (!is_instance_valid(resources)):
		printerr("Resources Path Incorrect or other failure");
func harvest() -> void:
	if (resources.have_resource(efficiency_ratio,refinery_source)):
		game.deduct_resource(refinery_source,efficiency_ratio);
		game.give_resource(refinery_output,1);
func start_refining() -> void:
	add_to_group(Common.group_resource_structure);
