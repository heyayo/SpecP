extends Node2D
class_name BossFinder

@onready var animation_player = $AnimationPlayer

@onready var spider;
@onready var camera_2d;

func _ready() -> void:
	visible = false;
	spider = get_tree().get_nodes_in_group("Boss").front();
	camera_2d = get_viewport().get_camera_2d();
#func _process(_delta) -> void:
	#global_position = camera_2d.global_position;
func point_nearest() -> void:
	animation_player.stop();
	animation_player.play("fade");
	look_at(spider.global_position);
	rotate(deg_to_rad(90));
