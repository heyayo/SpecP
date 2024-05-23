extends Node2D

class_name Worker;

var _tracker : Collision_Tracker = Collision_Tracker.new();
var work_target : Construction_Mark;

func work_on(mark : Construction_Mark) -> void:
	mark.tick_construction();

#region Reach Signals
func in_range(body : Node2D) -> void:
	if (body == get_parent()): return;
	_tracker.track(body);
func out_range(body : Node2D) -> void:
	_tracker.untrack(body);
#endregion
