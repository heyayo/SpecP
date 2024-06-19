extends Node2D

class_name Overseer

var units : Array[Unit];

func _input(_event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		move_units();

func move_units() -> void:
	for u : Unit in units:
		u.move_to(get_global_mouse_position());
