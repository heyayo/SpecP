extends CharacterBody2D
class_name Unit

#region Modules
@onready var nav_agent : UnitNavigator = $NavigationAgent2D;
@onready var sprite : Animator = $Animator;
@onready var walk_area : Detection = $"Walk Area";
@onready var attack_area : Detection = $"Attack Area";
@onready var attack_node = $Attack;
#endregion

@export_category("Unit Info")
@export var data : UnitStats;

var speed : float;
var health : float :
	get: return health;
	set(value):
		health = value;
		health = clamp(health,0,data.max_health);
		if (health <= 0):
			queue_free();
var target = null;

## TODO
# Rewrite Pathing with Passive/Aggressive Toggle
# Passive | Attack only on specified
# Aggressive | Attack all in range
# Specified Attack | Chase on exit
# Stop chasing when target is dead
#region NEW Pathing
var desired_target = null; ## The attacking target
var desired_position : Vector2;
#endregion

func _ready() -> void:
	set_collision_layer_value(Common.layer_unit,true);
	print("%s | Initialized Unit" % name);
	## Apply Attack Range
	attack_area.scale = data.unitrange();
	## Apply Defaults
	speed = data.speed;
	health = data.max_health;
	attack_node.cooldown = data.cooldown;
func _physics_process(_delta) -> void:
	if (nav_agent.is_navigation_finished()): return;
	if (sprite.attacking or attack_area.is_in_range(target)):
		velocity = Vector2.ZERO;
	else:
		apply_velocity();
func _process(_delta) -> void:
	apply_slowdown();
	if (!is_instance_valid(target)): target = null;
	if (target):
		attack_bev();

#region Behaviours
func attack_bev() -> void:
	if (attack_area.is_in_range(target)):
		if (!attack_node.on_cooldown):
			sprite.attack();
			attack_node.attack(target,data.damage);
	else:
		move_to(target.global_position);
#endregion
#region External
func move_to(pos : Vector2) -> void:
	nav_agent.target_position = pos;
func stop_move_to(pos : Vector2) -> void:
	move_to(pos);
	target = null;
func force_attack(unit) -> void:
	sprite.reset();
	apply_target(unit);
#endregion
#region Applications
func apply_null_target() -> void:
	target = null;
	move_to(global_position);
func apply_target(unit) -> void:
	if (target == unit): return;
	target = unit;
	move_to(target.global_position);
func apply_velocity() -> void:
	var direction : Vector2 = nav_agent.get_next_path_position() - global_position;
	var vel : Vector2 = direction * speed;
	nav_agent.velocity = vel;
func apply_slowdown() -> void:
	if (walk_area.is_empty()):
		speed = data.speed;
	else:
		speed = data.speed / data.slowdown;
#endregion
#region Signal Callbacks
func _velocity_computed_from_navigation_agent_2d(safe_velocity):
	if (sprite.attacking): return;
	velocity = safe_velocity;
	move_and_slide();
func _animation_finished_from_animator():
	if (is_instance_valid(target)):
		target.health -= data.damage;
#endregion
