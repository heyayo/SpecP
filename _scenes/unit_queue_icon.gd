extends ColorRect
class_name UnitQueueIcon

@onready var unit_name = $Name

func end() -> void:
	queue_free();
