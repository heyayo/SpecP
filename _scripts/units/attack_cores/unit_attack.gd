extends Timer
class_name UnitAttack

var on_cooldown : bool = false;
var cooldown : float = 1 :
	get: return cooldown;
	set(value):
		cooldown = value;
		wait_time = cooldown;

func _init() -> void:
	one_shot = true;
func _ready() -> void:
	timeout.connect(off_cooldown);
	wait_time = cooldown;
	print("%s | Initialized Unit Attack" % get_parent().name);
func attack(target, damage : int) -> void:
	pass
func off_cooldown() -> void:
	on_cooldown = false;
