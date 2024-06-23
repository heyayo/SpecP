extends Resource
class_name HostileStats

#region Stats
@export var aggro_range : int = 10;
@export var stat_overrides : UnitStats;
#endregion

func npcaggro() -> Vector2:
	return Vector2(aggro_range,aggro_range);
