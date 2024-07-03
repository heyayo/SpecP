extends TextureRect
class_name BossFinder

@onready var animation_player = $AnimationPlayer

@onready var spider = $"../../BossList/Spider"
@onready var camera_2d = $"../../Camera2D"

func _ready() -> void:
	visible = false;
func point_nearest() -> void:
	point_to(spider); ## TODO Actual sorting of nearest boss based on game progression
func point_to(unit : Unit) -> void:
	animation_player.stop();
	animation_player.play("fade");
	var diff : Vector2 = camera_2d.global_position.direction_to(spider.global_position);
	var rot : float = atan2(diff.y,diff.x);
	rotation = rot + 90
