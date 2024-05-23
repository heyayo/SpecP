extends Node2D

class_name Construction_Mark;

# Fetch the main building
@onready var building : Building = $"..";
@onready var body : StaticBody2D = $"..";
@onready var percent : Label = $BackgroundColor/Percentage;
@onready var progress : ColorRect = $BackgroundColor/ProgressColor;

var work : int = 0;

func _ready():
	building.remove_from_group(Common.group_structure)
	building.add_to_group(Common.group_construction);
	
	body.collision_layer = Common.cLayer_buildings;
	body.collision_mask = 0;
	update_ui(0);

func tick_construction(w : int = 1):
	work = clamp(work + w,0,building.structure_data.build_cost);
	var p : float = work as float / building.structure_data.build_cost as float;
	p = clamp(p,0,1);
	update_ui(p);
	if (work >= building.structure_data.build_cost):
		finish_construction();
		queue_free();

func finish_construction():
	building.remove_from_group(Common.group_construction);
	building.add_to_group(Common.group_structure);
	# TODO Call Structure's Script to finish

func update_ui(p : float):
	progress.scale = Vector2(p,1);
	percent.text = str(p * 100).pad_decimals(0) + '%';
