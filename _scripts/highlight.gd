extends Sprite2D

class_name Highlight

var target : Node2D = null;

func _process(_delta) -> void:
	global_position = target.global_position;

const one : float = 0.222;
func resize(size : int) -> void:
	var s : float = size * one;
	scale = Vector2(s,s);
func resize_v(size : Vector2) -> void:
	var s : Vector2 = size * one;
	scale = s;
