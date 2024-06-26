extends Resource
class_name HarvestStats

@export var type : Common.RESOURCE_TYPE;
@export var range : int = 5;
@export var amount : int = 1;
@export var required_amount : int = 1;

func rangevec2() -> Vector2i:
	return Vector2i(range,range);
