extends Node2D
class_name TempEffect

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("default");
func _animation_finished_from_animated_sprite_2d():
	queue_free();
