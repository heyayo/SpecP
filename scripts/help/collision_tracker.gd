class_name Collision_Tracker;

var _collection : Array[Node2D] = [];
func track(body : Node2D) -> void:
	if (_collection.find(body) < 0):
		_collection.push_back(body);
func untrack(body : Node2D) -> void:
	var index : int = _collection.find(body);
	if (index < 0): return;
	_collection.remove_at(index);
func empty() -> bool: return _collection.size() <= 0;
