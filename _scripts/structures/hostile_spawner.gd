extends Node2D
class_name HostileSpawner

@onready var game : Game = $"/root/Game";
@export var max_spawns : int = 1; ## Maximum number of Units spawned
@export var spawn_rate : float = 1; ## Spawn Rate in Seconds
@export var unit : PackedScene;
@export var core : PackedScene;

var spawn_timer : Timer;
var units : Array[Unit] = [];

func _init() -> void:
	spawn_timer = Timer.new();
	spawn_timer.autostart = false;
	spawn_timer.one_shot = true;
	spawn_timer.wait_time = spawn_rate;
	spawn_timer.timeout.connect(spawn_unit);
	add_child(spawn_timer);
func _ready() -> void:
	resume_spawns();
	print("%s | Initializing Unit Spawner" % get_parent().name);
func resume_spawns() -> void:
	if (units.size() >= max_spawns): return;
	print("Resuming Spawns");
	spawn_timer.start();
func spawn_unit() -> void:
	print("%s | Spawning Unit" % get_parent().name);
	var spawn : Unit = unit.instantiate();
	spawn.global_position = global_position;
	game.spawn_unit(spawn);
	spawn.tree_exiting.connect(report_death.bind(spawn));
	spawn.add_child(core.instantiate());
	spawn.add_to_group(Common.group_hostile);

	units.push_back(spawn);
	var random_direction : Vector2 = Vector2(15,0).rotated(deg_to_rad(randf_range(0,360))) * 4;
	spawn.move_to(random_direction + spawn.global_position);
	resume_spawns();

#region Unit Reports
func report_death(unit : Unit) -> void:
	print("%s | Unit Reported Death" % unit.name);
	units.erase(unit); ## Mark Unit as Dead
	resume_spawns(); ## Resume Unit Spawning
func report_damage(source, damage : float) -> void:
	for u in units:
		if (!is_instance_valid(u)): continue;
		if (is_instance_valid(u.desired_target)): continue;
		u.attack_action(source);
#endregion
