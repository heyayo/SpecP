extends CharacterBody2D

class_name Colonist

@onready var nav = $NavigationAgent2D
@onready var anim : CAnim = $AnimatedSprite2D;

@export var speed : float = 10;
var walk_pause : bool = false;

func _physics_process(_delta) -> void:
	do_walk();
#region Walk
func do_walk() -> bool:
	if (walk_pause):
		anim.direct(Vector2.ZERO);
		return false;
	if (nav.is_navigation_finished()):
		anim.direct(Vector2.ZERO);
		return false;
	var walk_dir : Vector2 = (nav.get_next_path_position() - global_position).normalized();
	velocity = walk_dir * speed;
	if (!move_and_slide()): return true;
	return true;
func start_walk(pos : Vector2) -> void:
	nav.target_position = pos;
	walk_pause = false;
func stop_walk() -> void:
	nav.target_position = global_position;
	walk_pause = false;
func pause_walk(pause : bool = true) -> void:
	walk_pause = pause;
#endregion
