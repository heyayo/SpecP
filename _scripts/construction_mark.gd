extends Node2D

class_name ConstructionMark

@onready var bg_progress : ColorRect = $BG_Progress;
@onready var fg_progress : ColorRect = $FG_Progress;

var data : Construct = null;
var progress : int = 0;

func _ready() -> void:
	resize_bar();
	get_parent().add_to_group(Common.group_construction);

func make(blueprint : Construct) -> ConstructionMark:
	data = blueprint;
	return self;

func tick_progress(amount : int) -> void:
	progress += amount;
	progress = clamp(progress,0,data.work_cost);
	resize_bar();
	if (progress >= data.work_cost):
		finish();
		queue_free();
func resize_bar() -> void:
	var perc : float = progress as float / data.work_cost as float;
	fg_progress.scale = Vector2(perc,1);

func finish() -> void:
	# TODO Spawn Purpose
	pass;

func interact() -> void:
	pass
