extends ColorRect

class_name InteractMenu

signal sig_ext_harvest(harvests : Array[Harvestable]);
signal sig_ext_produce;

@onready var harvest_bn : Button = $VBoxContainer/Harvest;
@onready var produce_bn : Button = $VBoxContainer/Produce;
@onready var desc : Label = $Summary;

var harvestables : Array[Harvestable];
var structures : Array[Structure];
var colonists : Array[Colonist];

func _ready():
	visible = false;
	harvest_bn.visible = false;
	produce_bn.visible = false;

#region Allocations
func allocate_resources(selection : Array) -> void:
	harvestables.clear();
	structures.clear();
	colonists.clear();
	for s in selection:
		if (s is Structure):
			structures.push_back(s);
			continue;
		if (s is Colonist):
			colonists.push_back(s);
			continue;
		if (s is Harvestable):
			harvestables.push_back(s);
			continue;
func allocate_desc() -> void:
	desc.text = "
	Harvestables: %s\n
	Structures: %s\n
	Colonists: %s\n
	" % [harvestables.size(), structures.size(), colonists.size()];
func allocate_buttons() -> void:
	produce_bn.visible = !structures.is_empty();
	harvest_bn.visible = !harvestables.is_empty();
#endregion

#region Signals
func callback_selector_select(selection):
	if (selection.is_empty()): return;
	print(selection);
	allocate_resources(selection);
	allocate_desc();
	allocate_buttons();
	visible = true;
func callback_selector_deselect():
	visible = false;
func callback_extend_harvest_pressed():
	sig_ext_harvest.emit(harvestables);
#endregion
