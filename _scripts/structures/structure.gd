extends Area2D
class_name Structure
## TODO Replace with 90 Degree Sprites
signal sig_finish_construction;
signal sig_destroyed;

@export var data : StructureData;
@onready var health_bar : HealthBar = $HealthBar

var health : int = 100 :
	get: return health;
	set(value):
		health = value;
		health_bar.update_bar(value,data.max_health);
		health = clamp(health,0,data.max_health);
		if (health <= 0):
			sig_destroyed.emit();
			queue_free();

func _ready() -> void:
	set_collision_layer_value(Common.layer_structure,true);
	print("%s | Initializing Structure" % name);
	health = data.max_health;
func finish_construction() -> void:
	print("%s | Constructed" % name);
	sig_finish_construction.emit();
func apply_damage(damage : float, source) -> void:
	health -= damage;
