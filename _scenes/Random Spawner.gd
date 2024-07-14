extends Node2D
class_name RandomSpawner

@onready var notification = $"../Interface/Notification"
@onready var timer : Timer = $Timer
@onready var game : Game = $"/root/Game";
@onready var audio_instancer = $AudioInstancer

var small_spider : PackedScene = preload("res://_scenes/npc/small_spider.tscn");
var base_raider : PackedScene = preload("res://_scenes/npc/cores/base_raider.tscn")

@export_category("Event Timings")
@export var minimum : float = 10;
@export var maximum : float = 120;

#region Audio Resources
const RAIN_OF_SPIDERS = preload("res://_audio/events/rain_of_spiders.ogg")
#endregion

func _ready() -> void:
	timer.wait_time = randf_range(minimum,maximum);
func run_event() -> void:
	pass
func rain_of_spiders() -> void:
	audio_instancer.play_instance(RAIN_OF_SPIDERS);
	const spider_count : int = 64;
	const radius : float = 150 * 16;
	const radial : float = (PI*2)/spider_count;
	for i in spider_count:
		var rad : float = radial * i;
		var offset : Vector2 = Vector2.UP.rotated(rad) * radius;
		var spider = small_spider.instantiate();
		spider_tracker.push_back(spider);
		spider.sig_death.connect(spider_death);
		spider.sig_damage_response.connect(alert_spiders);
		game.add_child(spider);
		spider.global_position = offset;
		spider.add_child(base_raider.instantiate());
func alert_spiders(source) -> void: ## Alert All Spiders when one is attacked
	for s in spider_tracker:
		if (is_instance_valid(s.desired_target)): continue;
		s.attack_action(source);
var spider_tracker : Array[Unit] = []
func spider_death(unit) -> void:
	spider_tracker.erase(unit);
func _timeout_from_timer():
	run_event();
