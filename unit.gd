extends CharacterBody2D

class_name Unit

#region Modules
@export var nav_agent : UnitNavigator;
@export var sprite : Animator;
@export var walk_area : Detection;
@export var attack_area : Detection;
#endregion

@export_category("Unit Info")
@export var object_data : WorldObject;
@export var training_time : int = 1;
@export_category("Unit Stats")
@export var base_speed : float = 5;
@export var range : int = 3;
@export var slowdown : float = 2;
@export var max_health : float = 100;
@export var base_health : float = 100;
@export var base_damage : float = 10;

var speed : float = base_speed;
var health : float = base_health :
	get: return health;
	set(value):
		health = value;
		health = clamp(health,0,max_health);
		if (health <= 0):
			queue_free();
var target : Unit = null;

func _ready() -> void:
	set_collision_layer_value(Common.layer_unit,true);
	print("%s | Initialized Unit" % name);
	## Apply Attack Range
	attack_area.scale = Vector2(range,range);
func _physics_process(_delta) -> void:
	if (nav_agent.is_navigation_finished()): return;
	apply_velocity();
func _process(_delta) -> void:
	apply_slowdown();
	if (!is_instance_valid(target)): target = null;
	if (target):
		attack_bev();

#region Behaviours
func attack_bev() -> void:
	if (attack_area.is_in_range(target)):
		sprite.attack();
	else:
		move_to(target.global_position);
#endregion
#region External
func move_to(pos : Vector2) -> void:
	nav_agent.target_position = pos;
func force_attack(unit : Unit) -> void:
	sprite.reset();
	apply_target(unit);
#endregion
#region Applications
func apply_null_target() -> void:
	target = null;
	move_to(global_position);
func apply_target(unit : Unit) -> void:
	if (target == unit): return;
	target = unit;
	move_to(target.global_position);
func apply_velocity() -> void:
	var direction : Vector2 = nav_agent.get_next_path_position() - global_position;
	var vel : Vector2 = direction * speed;
	nav_agent.velocity = vel;
func apply_slowdown() -> void:
	if (walk_area.is_empty()):
		speed = base_speed;
	else:
		speed = base_speed / slowdown;
#endregion
func _velocity_computed_from_navigation_agent_2d(safe_velocity):
	velocity = safe_velocity;
	move_and_slide();

func _animation_finished_from_animator():
	if (target):
		target.health -= base_damage;
