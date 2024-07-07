extends Node2D
class_name RandomSpawner

@onready var notification = $"../Interface/Notification"
@onready var timer : Timer = $Timer

@export_category("Event Timings")
@export var minimum : float = 10;
@export var maximum : float = 120;

func _ready() -> void:
	timer.wait_time = randf_range(minimum,maximum);
func run_event() -> void:
	pass

func _timeout_from_timer():
	run_event();
