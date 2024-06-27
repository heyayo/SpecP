extends UnitAttack
class_name UnitMelee

func attack(target, damage : int) -> void:
	if (on_cooldown): return;
	target.apply_damage(damage,get_parent());
	on_cooldown = true;
	start();
