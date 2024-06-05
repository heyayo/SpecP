extends NavigationAgent2D

class_name C_Nav

@onready var colonist : Colonist = get_parent();

var pathing : bool = false;
var current_target : Node2D = null;

func begin_path_to(target : Node2D) -> bool:
	if (target.global_position == target_position): return true;
	target_position = target.global_position;
	pathing = true;
	return true; # TODO Check if path is good
func stop_path() -> void:
	target_position = get_parent().global_position;
func resume_path() -> void:
	pathing = true;
func pause_path() -> void:
	pathing = false;
