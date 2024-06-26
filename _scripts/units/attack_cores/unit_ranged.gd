extends UnitAttack
class_name UnitRanged

@export var projectile : PackedScene;
@onready var game : Game = $"/root/Game";
@onready var parent : Node2D = get_parent();

func attack(target, damage : int) -> void:
	if (on_cooldown): return;
	on_cooldown = true;
	if (!is_instance_valid(target)): return;
	var proj : Projectile = projectile.instantiate();
	game.add_child(proj);
	proj.setup(damage, target);
	proj.global_position = parent.global_position;
	start();
