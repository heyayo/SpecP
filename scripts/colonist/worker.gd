extends Node2D

class_name Worker;

var _tracker : Collision_Tracker = Collision_Tracker.new();

func work_on(mark : Construction_Mark) -> void:
	mark.tick_construction();

func highlight_interactable() -> void:
	if (_tracker.empty()): return;
	var work_target : Work_Target = _tracker.collection[0];

func interact() -> void:
	if (_tracker.empty()): return;
	var work_target : Work_Target = _tracker.collection[0];
	work_target.callback.call();
	print("Interacted with %s" % work_target.get_parent());

#region Reach Signals
func in_range(body : Node2D) -> void:
	if (body == get_parent()): return;
	_tracker.track(body);
func out_range(body : Node2D) -> void:
	_tracker.untrack(body);
#endregion
