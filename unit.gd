extends CharacterBody2D

class_name Unit

@onready var nav_agent : UnitNavigator = $NavigationAgent2D
@onready var walkover = $Walkover

@export var object_data : WorldObject;
@export var training_time : int = 1;
@export var speed : float = 5;
var slowdown : float = 1;

func _ready() -> void:
	set_collision_layer_value(Common.layer_unit,true);
	print("%s | Initialized Unit" % name);
func _physics_process(_delta) -> void:
	if (nav_agent.is_navigation_finished()): return;
	body_velocity();

func move_to(pos : Vector2) -> void:
	nav_agent.target_position = pos;
func body_velocity() -> void:
	var direction : Vector2 = nav_agent.get_next_path_position() - global_position;
	var vel : Vector2 = direction * speed;
	nav_agent.velocity = vel * slowdown;

func _velocity_computed_from_navigation_agent_2d(safe_velocity):
	velocity = safe_velocity;
	move_and_slide();

#region Walkover Callbacks
func _sig_detect_enter_from_walkover(node):
	print("%s | Walked Over" % node.name)
	slowdown = 0.5 if walkover.is_empty() else 1;
func _sig_detect_exit_from_walkover(node):
	print("%s | Walked Out" % node.name)
	slowdown = 0.5 if walkover.is_empty() else 1;
#endregion
