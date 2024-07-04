extends Resource
class_name StructureData

#region Identification
@export var name : String;
@export_multiline var desc : String;
#endregion
#region Costs
@export var work : int = 1;
@export var wood : int = 0;
@export var food : int = 0;
@export var stone : int = 0;
@export var metal : int = 0;
#endregion
#region Stats
@export var max_health : int = 100;
@export var defense_range : float = 0; ## Compatiblity
@export var range : int = 10; ## Compatiblity
#endregion
