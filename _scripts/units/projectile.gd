extends Node2D
class_name Projectile

@export var speed : float = 1;
var damage : int = 1;
var target : Node2D = null;
var source = null;

func setup(d : int, t : Node2D, o) -> void:
	damage = d;
	target = t;
	source = o;
	#print("Fired Projectile | Speed: %s | Damage: %s | Target: %s" % [speed,damage,target.name]);

func _process(_delta) -> void:
	if (!is_instance_valid(target)):
		queue_free();
		return;
	look_at(target.global_position);
func _physics_process(delta):
	if (!is_instance_valid(target)): return;
	global_position = global_position.move_toward(target.global_position,speed);
	var diff : Vector2 = target.global_position - global_position;
	if (diff.abs() <= Vector2(1,1)):
		target.apply_damage(damage,source);
		queue_free();
