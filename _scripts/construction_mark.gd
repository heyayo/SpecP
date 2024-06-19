extends Node2D

class_name ConstructionMark

@onready var bg_progress : ColorRect = $BG_Progress;
@onready var fg_progress : ColorRect = $FG_Progress;
@onready var timer = $Timer

var cost : int = 10;

func _ready() -> void:
	resize_bar(0);
	get_parent().add_to_group(Common.group_construction);
	timer.wait_time = cost;
	timer.start();
	get_parent().get_node("Sprite2D").self_modulate = Color.DEEP_PINK;
func _process(_delta) -> void:
	resize_bar(cost as float - timer.time_left);
func resize_bar(progress : float) -> void:
	var perc : float = progress / cost as float;
	fg_progress.scale = Vector2(perc,1);
func _timeout_from_timer():
	var structure : Structure = get_parent();
	structure.get_node("Sprite2D").self_modulate = Color.WHITE;
	structure.finish_construction();
	queue_free();
