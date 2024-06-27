extends CharacterBody2D
class_name UnitRewrite ## TODO Rename
#region Modules
@onready var sprite : Animator = $Animator;
@onready var nav : UnitNavigator = $NavigationAgent2D;
@onready var walk_area : Detection = $"Walk Area";
@onready var attack_area : Detection = $"Attack Area";
@onready var attack_node : UnitAttack = $Attack;
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
var desired_target : UnitRewrite = null;
var recent_attacker : UnitRewrite = null;
var behaviour : BEHAVIOUR = BEHAVIOUR.PASSIVE;
#endregion
#region Processes
func _ready() -> void:
	attack_area.scale = data.unitrange();
	speed = data.speed;
	health = data.max_health;
	desired_position = global_position;
func _process(_delta) -> void:
	lock_move = sprite.attacking or attack_area.is_in_range(desired_target) or attack_area.is_in_range(recent_attacker);
	apply_slowdown();
	match behaviour:
		BEHAVIOUR.PASSIVE:
			passive_bev();
		BEHAVIOUR.DEFENSIVE:
			defensive_bev();
		BEHAVIOUR.AGGRESSIVE:
			aggressive_bev();
func _physics_process(_delta):
	if (nav.is_navigation_finished()): return;
	apply_velocity();
#endregion
#region Actions
func move_action(pos : Vector2) -> void:
	desired_position = pos;
	nav.target_position = pos;
func attack_action(target : UnitRewrite) -> void:
	if (!is_instance_valid(target)): return;
	desired_target = target;
	move_action(target.global_position);
func defense_action(source : UnitRewrite) -> void:
	if (!is_instance_valid(source)): return;
	recent_attacker = source;
	move_action(source.global_position);
#endregion
#region Behaviours
func passive_bev() -> void:
	force_attack_response();
func defensive_bev() -> void:
	var diff : Vector2 = desired_target.global_position - desired_position;
	var ret_dist : int = desired_target.data.range;
	if (diff.abs() >= Vector2(ret_dist,ret_dist)):
		desired_target = null;
		move_action(desired_position);
		return;
	force_attack_response();
func aggressive_bev() -> void:
	if (!is_instance_valid(desired_target)):
		if (attack_area.is_empty()):
			return;
		desired_target = get_lowest_health();
		print(desired_target);
		return;
	force_attack_response();
func damage_response(source : UnitRewrite) -> void:
	match behaviour:
		BEHAVIOUR.DEFENSIVE:
			defense_action(source);
		BEHAVIOUR.AGGRESSIVE:
			attack_action(source);
func force_attack_response() -> void:
	if (!is_instance_valid(desired_target)):
		return;
	if (attack_area.is_in_range(desired_target)):
		if (!attack_node.on_cooldown):
			sprite.attack();
			attack_node.attack(desired_target,data.damage);
	else:
		move_action(desired_target.global_position);
func get_lowest_health() -> UnitRewrite:
	var lowest : float = 0;
	var lowest_unit : UnitRewrite = null;
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
func apply_damage(damage : float, source : UnitRewrite) -> void:
	health -= damage;
	if (!is_instance_valid(source)): return;
	if (health <= 0):
		source.report_death(self);
	damage_response(source);
func apply_velocity() -> void:
	var direction : Vector2 = nav.get_next_path_position() - global_position;
	var vel : Vector2 = direction * speed;
	nav.velocity = vel;
#endregion
#region Callbacks
func _nav_safe_velocity(safe : Vector2) -> void:
	if (lock_move): return;
	velocity = safe;
	move_and_slide();
func report_death(unit : UnitRewrite) -> void:
	if (desired_target != unit): return;
	move_action(global_position);
#endregion
