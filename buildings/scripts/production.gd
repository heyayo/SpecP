extends Building

class_name Production;

@export_category("Configuration")
@export var max_capacity : int;

var capacity : int:
	get: return capacity;
	set(value):
		capacity = clamp(value,0,max_capacity);
