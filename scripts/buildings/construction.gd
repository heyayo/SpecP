extends Node2D

class_name Construction;

# Fetch the main building
@onready var building : Building = $"..";
@onready var body : StaticBody2D = $"..";
@onready var percent : Label = $BackgroundColor/Percentage;
@onready var progress : ColorRect = $BackgroundColor/ProgressColor;

@onready var timer : Timer = $"Timer";

func _ready():
	if (building.is_in_group(Common.group_structure)):
		building.remove_from_group(Common.group_structure)
	building.add_to_group(Common.group_construction);
	timer.wait_time = building.time;
	timer.start();
	timer.one_shot = true;
	body.collision_layer = Common.cLayer_buildings;
	body.collision_mask = 0;

func _process(delta):
	var opacity : float = (timer.wait_time - timer.time_left) / timer.wait_time;
	building.modulate.a = opacity;
	percent.text = str(opacity * 100).pad_decimals(0) + '%';
	var progressScale : Vector2 = Vector2(opacity * 100, 40);
	progress.size = progressScale;

func _on_timer_timeout():
	building.add_to_group(Common.group_structure);
	building.remove_from_group(Common.group_construction);
	queue_free(); # Remove Mark
	pass # Replace with function body.
