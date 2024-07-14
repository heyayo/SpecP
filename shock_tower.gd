extends Node2D
class_name ShockTower

@onready var timer = $Timer
@onready var range = $Range
@onready var stream_player = $AudioStreamPlayer

@export var cooldown : float = 5;
@export var max_pierce : int = 5;
@export var damage : float = 125;

func _ready():
	timer.wait_time = cooldown;
	disable();
func _process(_delta) -> void:
	if (!timer.is_stopped()): return;
	if (range.is_empty()): return;
	timer.start();
	stream_player.stop();
	stream_player.play();
	var pierce : int = 0;
	for target in range.tracker.collection:
		if (pierce > max_pierce): break;
		pierce += 1;
		if (!is_instance_valid(target)): continue;
		strike(target);
		## TODO Continue Shock Tower

func strike(target) -> void:
	target.apply_damage(damage,get_parent());

func disable() -> void:
	set_process(false);
func enable() -> void:
	set_process(true);
func why(body) -> void:
	print(body);
	print(range.global_position);
	print(body.global_position);
