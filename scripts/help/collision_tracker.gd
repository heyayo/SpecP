class_name Collision_Tracker;

var collection : Array[Node2D] = [];
func track(body : Node2D) -> void:
	if (collection.find(body) < 0):
		collection.push_back(body);
func untrack(body : Node2D) -> void:
	var index : int = collection.find(body);
	if (index < 0): return;
	collection.remove_at(index);
func empty() -> bool: return collection.size() <= 0;
