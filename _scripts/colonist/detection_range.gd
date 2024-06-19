extends Area2D

class_name Detection

signal sig_detect_enter(node);
signal sig_detect_exit(node);

var tracker : Tracker = Tracker.new();
#region Tracker Signals
func _on_body_entered(body):
	sig_detect_enter.emit(body);
	tracker.track(body);
func _on_body_exited(body):
	sig_detect_exit.emit(body);
	tracker.untrack(body);
#endregion

func is_in_range(node : Node2D) -> bool:
	var index : int = tracker.collection.find(node);
	return index >= 0;
func is_empty() -> bool:
	return tracker.collection.is_empty();
