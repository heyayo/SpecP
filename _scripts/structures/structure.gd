extends Area2D
class_name Structure

@export var data : StructureData;
var health : int = 100 :
	get: return health;
	set(value):
		health = value;
		health = clamp(health,0,data.max_health);
		if (health <= 0):
			queue_free();

func _ready() -> void:
	set_collision_layer_value(Common.layer_structure,true);
	print("%s | Initializing Structure" % name);
	health = data.max_health;

func finish_construction() -> void:
	print("%s | Constructed" % name);
