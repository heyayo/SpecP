extends Resource
class_name UnitStats
#region Identification Exports
@export var name : String;
@export_multiline var desc : String;
@export var preview : Texture;
#endregion
#region Stats
@export var training_time : int = 1;
@export var damage : float = 10;
@export var speed : float = 5;
@export var max_health : float = 100;
@export var range : int = 3;
@export var slowdown : float = 2;
@export var cooldown : float = 1;
#endregion
#region Convenience Functions
func unitrange() -> Vector2:
	return Vector2(range,range);
#endregion
