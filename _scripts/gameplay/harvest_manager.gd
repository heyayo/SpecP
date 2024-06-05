extends Node2D

class_name HarvestManager

signal sig_add_harvest(harvest : Harvestable);
signal sig_remove_harvest(harvest : Harvestable);

var harvest_prefab : PackedScene = preload("res://_scenes/prefabs/harvestable.tscn");
var resource_prefab : PackedScene = preload("res://_scenes/prefabs/resource_item.tscn");

func add_harvestable(blueprint : HarvestableData) -> Harvestable:
	var h : Harvestable = harvest_prefab.instantiate().make(blueprint);
	add_child(h);
	sig_add_harvest.emit(h);
	h.sig_harvest.connect(callback_extend_harvest);
	return h;
func remove_harvestable(harvestable : Harvestable) -> void:
	sig_remove_harvest.emit(harvestable);
	harvestable.queue_free();
func harvest(harvestable : Harvestable) -> void:
	for drop in harvestable.data.drops:
		# TODO Drop items on harvest
		break;
	remove_harvestable(harvestable);

func callback_extend_harvest(harvest):
	remove_harvestable(harvest);
