extends Node2D

class_name Overseer

signal sig_manual_on;
signal sig_manual_off;

var cprefab = preload("res://_scenes/prefabs/colonist.tscn");

@onready var debug_target : Node2D = $Debug_Target;

var all_colonists : Array[Colonist] = [];
var manual_colonist : Colonist = null;

var manual : bool = false :
	get: return manual;
	set(value):
		manual = value;
		if (manual_colonist == null): manual = false;
		if (manual):
			sig_manual_on.emit();
			set_process_input(true);
		else:
			sig_manual_off.emit();
			set_process_input(false);

func _ready() -> void:
	manual = false;
	var c = spawn_colonist();
func _input(event : InputEvent) -> void:
	var direction = Input.get_vector("Left","Right","Up","Down");
	manual_colonist.move(direction);

# TODO Overseer Functions
func spawn_colonist() -> Colonist:
	var c = cprefab.instantiate();
	add_child(c);
	register(c);
	return c;
func despawn_colonist(colonist : Colonist) -> void:
	unregister(colonist);
	colonist.queue_free();
func register(colonist : Colonist) -> void:
	all_colonists.push_back(colonist);
func unregister(colonist : Colonist) -> void:
	var index = all_colonists.find(colonist);
	if (index >= 0):
		all_colonists.remove_at(index);
func colonist_manual_on(c : Colonist) -> void:
	manual_colonist = c;
func colonist_manual_off() -> void:
	manual_colonist = null;

#region Signals
# TODO Task Distribution System | Queue Backlogged Tasks for when a new colonist is created
func callback_request_build(s : Structure) -> void:
	var c : Colonist = all_colonists.front();
	if (!c): return;
	c.tasker.request_build(s);
	print("Requesting Build");
func callback_request_harvests(harvests : Array[Harvestable]) -> void:
	var c : Colonist = all_colonists.front();
	if (!c): return;
	for h in harvests:
		c.tasker.request_harvest(h);
	print("Requesting Harvests");
#endregion
