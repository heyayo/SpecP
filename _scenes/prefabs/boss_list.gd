extends Node2D
class_name BossList

@onready var spider : Unit = $Spider
@export var world_config : WorldConfiguration;

const world_edge : int = 25;
const cell_step : int = 50;
const spawn_radius : int = 150;

func _ready() -> void:
	calculate_cells();
	var spider_spawn := random_spawn();
	spider.global_position = spider_spawn;
	spider.move_to(spider_spawn);
	print("Spawning Spider at | %s" % spider_spawn);

var cells : Array[Vector2i];
func calculate_cells() -> void:
	var wsize : Vector2i = world_config.world_size;
	var xamt : int = wsize.x / cell_step / 2;
	var yamt : int = wsize.y / cell_step / 2;
	for x in range(-xamt,xamt):
		for y in range(-yamt,yamt):
			var center : Vector2i = Vector2i(x * 50,y * 50);
			if (center.abs() <= Vector2i(spawn_radius,spawn_radius)): continue;
			cells.push_back(center);
	var index : int = cells.find(Vector2i(0,0));
	print("World Center Cell | %s" % index);
	cells.erase(Vector2i(0,0));
	print(cells);
func random_spawn() -> Vector2:
	var index : int = randi_range(0,cells.size()-1);
	var ret : Vector2 = cells[index] * 16;
	cells.remove_at(index);
	return ret;
