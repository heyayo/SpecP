extends CharacterBody2D
class_name Unit
#region Modules
@onready var sprite : Animator = $Animator;
@onready var walk_area : Detection = $"Walk Area";
@onready var attack_area : Detection = $"Attack Area";
@onready var distance_from_others : Detection = $DistanceFromOthers
@onready var attack_node : UnitAttack = $Attack;
#endregion
#region Signals
signal sig_attack_action(target);
#endregion
#region Stores
enum BEHAVIOUR
{
	PASSIVE, ## Only attacks when requested to
	DEFENSIVE, ## Attacks Enemies in Range
	AGGRESSIVE ## Chases Enemies past Range
}
@export var data : UnitStats;
var lock_move : bool = false;
var speed : float = 5;
var health : float = 100 :
	get: return health;
	set(value):
		health = value;
		health = clamp(health,0,data.max_health);
		if (health <= 0):
			queue_free();
var desired_position : Vector2;
var desired_target = null;
var focus_attack : bool = true;
var behaviour : BEHAVIOUR = BEHAVIOUR.PASSIVE;
#endregion
#region Processes
func _ready() -> void:
	attack_area.scale = data.unitrange();
	speed = data.speed;
	health = data.max_health;
	desired_position = global_position;
func _process(_delta) -> void:
	if (is_instance_valid(desired_target)):
		lock_move = sprite.attacking or attack_area.is_in_range(desired_target);
	else: lock_move = sprite.attacking;
	apply_slowdown();
	match behaviour:
		BEHAVIOUR.PASSIVE: passive_bev();
		BEHAVIOUR.DEFENSIVE: defensive_bev();
		BEHAVIOUR.AGGRESSIVE: aggressive_bev();
const lazy_speed_adjust : float = 25; ## Moving from PathFinding to regular movement requires a speedboost
func _physics_process(_delta):
	var goto : Vector2;
	if (is_instance_valid(desired_target) and focus_attack):
		goto = desired_target.global_position;
	else: goto = desired_position;
	if (lock_move): return;
	var dist : Vector2 = (goto - global_position).abs();
	const close_distance : float = 5;
	if (dist.x < close_distance and dist.y < close_distance):
		velocity = Vector2.ZERO;
		return;
	velocity = global_position.direction_to(goto) * speed * lazy_speed_adjust;
	if (!distance_from_others.is_empty()):
		for u in distance_from_others.tracker.collection:
			velocity -= global_position.direction_to(u.global_position) * 10;
	move_and_slide();
#endregion
#region Actions
func move_action(pos : Vector2) -> void:
	move_to(pos);
	match (behaviour):
		BEHAVIOUR.PASSIVE: desired_target = null;
func attack_action(target) -> void:
	if (!is_instance_valid(target)): return;
	## DEBUG
	if (!target is Unit and !target is Structure):
		print("Attempted Attack on non-world object");
	desired_target = target;
	sig_attack_action.emit(desired_target);
func move_to(pos : Vector2) -> void:
	desired_position = pos;
#endregion
#region Behaviours
func passive_bev() -> void:
	force_attack_response();
func defensive_bev() -> void:
	if (!is_instance_valid(desired_target)):
		desired_target = null;
		return;
	var diff : Vector2 = desired_target.global_position - global_position;
	var ret_dist : int = (desired_target.data.range + data.range + data.defense_range) * 8;
	if (diff.abs() >= Vector2(ret_dist,ret_dist)):
		print_rich("[color=red]Target Left Range[/color]");
		print_rich("[color=green]Return Distance %s | Difference %s | ABS Difference %s[/color]" % [ret_dist,diff,diff.abs()]);
		desired_target = null;
		return;
	force_attack_response();
func aggressive_bev() -> void:
	if (!is_instance_valid(desired_target)):
		if (attack_area.is_empty()):
			return;
		desired_target = get_lowest_health();
		return;
	force_attack_response();
func damage_response(source) -> void:
	if (behaviour == BEHAVIOUR.PASSIVE): return;
	attack_action(source);
func force_attack_response() -> void:
	if (!is_instance_valid(desired_target)):
		return;
	if (attack_area.is_in_range(desired_target)):
		if (attack_node.on_cooldown):
			return;
		sprite.attack();
		attack_node.attack(desired_target,data.damage);
func get_lowest_health() -> Unit:
	var lowest : float = 0;
	var lowest_unit : Unit = null;
	for n in attack_area.tracker.collection:
		if (!is_instance_valid(n)): continue;
		if (n.health < lowest):
			lowest_unit = n;
			lowest = n.health;
	return null;
#endregion
#region Applications
func apply_slowdown() -> void:
	if (walk_area.is_empty()): speed = data.speed;
	else: speed = data.speed / data.slowdown;
func apply_damage(damage : float, source) -> void:
	health -= damage;
	if (!is_instance_valid(source)): return;
	if (health <= 0):
		source.report_death(self);
	damage_response(source);
#endregion
#region Callbacks
func report_death(unit) -> void:
	if (desired_target != unit): return;
	print("Unit Death Reported %s" % unit);
	desired_target = null;
#endregion
