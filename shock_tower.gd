extends Node2D
class_name ShockTower

@onready var timer = $Timer
@onready var range:Area2D = $Range
@onready var stream_player = $AudioStreamPlayer

@export var cooldown : float = 5;
@export var max_pierce : int = 5;
@export var damage : float = 125;

var hit_effect = preload("res://_scenes/prefabs/lightning_effect.tscn");

func _ready():
	timer.wait_time = cooldown;
	disable();
func _process(_delta) -> void:
	if (timer.time_left > 0): return;
	var targets = range.get_overlapping_bodies();
	if (targets.is_empty()): return;
	timer.start();
	stream_player.stop();
	stream_player.play();
	var pierce : int = 0;
	for target in targets:
		if (pierce > max_pierce): break;
		pierce += 1;
		if (!is_instance_valid(target)): continue;
		strike(target);

func strike(target) -> void:
	var effect : TempEffect = hit_effect.instantiate();
	effect.global_position = target.global_position;
	Game.get_game().add_child(effect);
	target.apply_damage(damage,get_parent());

func disable() -> void:
	set_process(false);
func enable() -> void:
	set_process(true);
