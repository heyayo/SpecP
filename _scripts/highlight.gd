extends Sprite2D

class_name Highlight

var target : Node2D = null;

func _process(_delta) -> void:
	global_position = target.global_position;
