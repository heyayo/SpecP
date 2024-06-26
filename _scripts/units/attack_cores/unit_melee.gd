extends UnitAttack
class_name UnitMelee

func attack(target, damage : int) -> void:
	if (on_cooldown): return;
	target.health -= damage;
	on_cooldown = true;
	start();
