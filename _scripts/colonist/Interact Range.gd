extends Area2D

class_name Detection

var tracker : Tracker = Tracker.new();
#region Tracker Signals
func _on_body_entered(body):
	tracker.track(body);
func _on_body_exited(body):
	tracker.untrack(body);
#endregion

func is_in_range(node : Node2D) -> bool:
	var index : int = tracker.collection.find(node);
	return index >= 0;
