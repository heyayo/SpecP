extends Node2D

class_name MResource

@export var labels : ResourceLabels;

@export_category("Resources")
@export var wood : int = 500 :
	get: return wood;
	set(value):
		wood = value;
		labels.set_wood(value);
@export var food : int = 500 :
	get: return food;
	set(value):
		food = value;
		labels.set_food(value);
@export var stone : int = 500 :
	get: return stone;
	set(value):
		stone = value;
		labels.set_stone(value);

func _ready() -> void:
	labels.call_deferred("set_all",self);
