extends Structure

class_name ResourceStructure

signal sig_harvest(type : Common.RESOURCE_TYPE, amount : int);

@export var stats : HarvestStats;

func _ready() -> void:
	super._ready();
	print("%s | Initializing Resource Structure" % name)
func finish_construction() -> void:
	add_to_group(Common.group_resource_structure);
	print("%s | Constructed Resource Structure" % name);
func harvest() -> void:
	sig_harvest.emit(stats.type,stats.amount);
