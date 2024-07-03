extends ColorRect

class_name ResourceLabels

@onready var wood_count : Label = $HBoxContainer/Wood/Icon/TitleCount;
@onready var food_count : Label = $HBoxContainer/Food/Icon/TitleCount;
@onready var stone_count : Label = $HBoxContainer/Stone/Icon/TitleCount;
@onready var metal_count = $HBoxContainer/Metal/Icon/TitleCount

func set_wood(amount : int) -> void:
	wood_count.text = "Wood: %s" % amount;
func set_food(amount : int) -> void:
	food_count.text = "Food: %s" % amount;
func set_stone(amount : int) -> void:
	stone_count.text = "Stone: %s" % amount;
func set_metal(amount : int) -> void:
	metal_count.text = "Metal: %s" % amount;
func set_all(resources : MResource) -> void:
	set_wood(resources.wood);
	set_food(resources.food);
	set_stone(resources.stone);
	set_metal(resources.metal);
