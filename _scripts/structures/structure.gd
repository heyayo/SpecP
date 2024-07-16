extends Area2D
class_name Structure
signal sig_finish_construction;
signal sig_destroyed;
signal sig_damaged(source, damage);

@export var data : StructureData;
@onready var health_bar : HealthBar = $HealthBar

var health : int = 100 :
	get: return health;
	set(value):
		if (is_instance_valid(health_bar)):
			health_bar.appear();
		health = value;
		if (is_instance_valid(health_bar)):
			health_bar.update_bar(value,data.max_health);
		health = clamp(health,0,data.max_health);
		if (health <= 0):
			sig_destroyed.emit();
			queue_free();

func save() -> Dictionary:
	var data : Dictionary = {
		"x":global_position.x,
		"y":global_position.y,
		"health":health,
		"res":scene_file_path
	}
	return data;
static func from_json(data : Dictionary) -> Structure:
	var scene = load(data["res"]);
	var s : Structure = scene.instantiate();
	s.global_position = Vector2(data["x"],data["y"]);
	s.health = data["health"];
	return s;

func _ready() -> void:
	set_collision_layer_value(Common.layer_structure,true);
	print("%s | Initializing Structure" % name);
	health = data.max_health;
	add_to_group(Common.group_persist);
func finish_construction() -> void:
	print("%s | Constructed" % name);
	sig_finish_construction.emit();
func apply_damage(damage : float, source) -> void:
	health -= damage;
	sig_damaged.emit(source,damage);
func report_death(source) -> void:
	pass
