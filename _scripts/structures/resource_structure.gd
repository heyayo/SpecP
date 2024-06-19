extends Structure

class_name ResourceStructure

signal sig_harvest(type : Common.RESOURCE_TYPE, amount : int);

@onready var resource_timer = $"Resource Timer";

@export var resource_type : Common.RESOURCE_TYPE; ## The resource this building generates
@export var harvest_range : int;
@export var harvest_rate : int; ## Amount of [resource_type] harvested each second

func _ready() -> void:
	super._ready();
	resource_timer.timeout.connect(_timeout_from_resource_timer);
	print("%s | Initializing Resource Structure" % name)
func finish_construction() -> void:
	resource_timer.start();
	print("%s | Constructed Resource Structure" % name);

#region Signals
func _timeout_from_resource_timer():
	sig_harvest.emit(resource_type,harvest_rate);
	print("Harvesting [%s] Resource [%s]" % [harvest_rate,str(resource_type)])
#endregion
