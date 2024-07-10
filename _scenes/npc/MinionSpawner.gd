extends Node2D
class_name MinionSpawner

@onready var game : Game = $"/root/Game";
@onready var timer = $Timer
@onready var parent : Unit = get_parent();
@export var minion : PackedScene;
@export var max_minions : int = 1;
@export var space : float = 10;
var minions : Array[Unit] = []

func _ready() -> void:
	timer.start();

func spawn_minion() -> void:
	var spawn : Unit = minion.instantiate();
	game.spawn_unit(spawn);
	spawn.global_position = global_position;
	spawn.tree_exiting.connect(report_death.bind(spawn));
	spawn.add_to_group(Common.group_hostile);
	spawn.sig_attack_action.connect(parent.attack_action);
	spawn.sig_attack_action.connect(attack_action);

	minions.push_back(spawn);
	var random_direction : Vector2 = Vector2(15,0).rotated(deg_to_rad(randf_range(0,360))) * space;
	spawn.move_to(random_direction + spawn.global_position);
	
	resume_spawning();
func resume_spawning() -> void:
	if (minions.size() >= max_minions): return;
	print("Resuming Spawns");
	timer.start();
func report_death(unit : Unit) -> void:
	minions.erase(unit);
	if (is_instance_valid(unit.desired_target)):
		parent.attack_action(unit.desired_target);
	resume_spawning();
func attack_action(target) -> void:
	if (!is_instance_valid(target)): return;
	for u in minions:
		u.desired_target = target;

func _timeout_from_timer():
	spawn_minion();
