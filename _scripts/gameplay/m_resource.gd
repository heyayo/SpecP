extends Node2D

class_name MResource

@export var labels : ResourceLabels;
@export_category("Resources")
var wood : int = 500 :
	get: return wood;
	set(value):
		wood = value;
		labels.set_wood(value);
var food : int = 500 :
	get: return food;
	set(value):
		food = value;
		labels.set_food(value);
var stone : int = 500 :
	get: return stone;
	set(value):
		stone = value;
		labels.set_stone(value);
var metal : int = 500 :
	get: return metal;
	set(value):
		metal = value;
		labels.set_metal(value);

func _ready() -> void:
	labels.call_deferred("set_all",self);
func have_resource(amount : int, type : Common.RESOURCE_TYPE) -> bool:
	match (type):
		Common.RESOURCE_TYPE.WOOD:
			return wood >= amount;
		Common.RESOURCE_TYPE.FOOD:
			return food >= amount;
		Common.RESOURCE_TYPE.STONE:
			return stone >= amount;
		Common.RESOURCE_TYPE.METAL:
			return metal >= amount;
	return false;

@onready var tree : SceneTree = get_tree();
func _timeout_from_timer():
	tree.call_group(Common.group_resource_structure,"harvest");
