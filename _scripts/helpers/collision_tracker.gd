class_name Tracker

# Collision Tracker Class
# A Structure for keeping track of unique collision objects
## Should probably combine with [Detection] class

var collection : Array = [];

func track(object) -> void:
	if (collection.find(object) >= 0): return;
	collection.push_back(object);

func untrack(object) -> void:
	var index : int = collection.find(object);
	if (index < 0): return;
	collection.remove_at(index);
