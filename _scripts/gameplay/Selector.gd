extends Area2D

class_name Selector

#region External
@onready var interact_menu : InteractMenu = $"../Interface/Interact Menu"
@onready var overseer : Overseer = $"../Overseer"
@onready var bills : Bills = $"../Interface/Bills"
@onready var base = $"../Base"
#endregion

var tracker : Tracker = Tracker.new();
var selection : Array = [];
var selecting : bool = false;
# FIXME Selection Glitches | Selection sometimes unresponsive, demolish button double takes
func _ready() -> void:
	visible = false;
func _input(_event : InputEvent) -> void:
	if (Input.is_action_pressed("Left_Click") and selecting):
		resize_selector();
func _unhandled_input(_event : InputEvent) -> void:
	if (Input.is_action_just_released("Left_Click")):
		selection = tracker.collection.duplicate();
		highlight_selected();
		reset_selector();
		
		interact_menu.show_actions(selection);
		overseer.units = get_friendly_units();
	if (Input.is_action_just_pressed("Left_Click")):
		clear_highlights();
		selection.clear();
		start_selector();
		
		interact_menu.hide_actions();
#region Highlighting
func highlight_selected() -> void:
	for n : Selectable in selection:
		n.enable();
func clear_highlights() -> void:
	get_tree().call_group(Common.group_selectable,"disable");
	#for n : Selectable in selection:
		#n.disable();
#endregion
#region Selector Functions
const min_drag_distance : int = 8;
var start_position : Vector2;
func resize_selector() -> void:
	var mouse_position = get_global_mouse_position();
	var diff : Vector2 = mouse_position - start_position;
	if (absf(diff.x) <= min_drag_distance and absf(diff.y) <= min_drag_distance):
		scale = Vector2(1,1);
		return;
	var midpoint : Vector2 = mouse_position - (diff / 2);
	global_position = midpoint;
	scale = diff;
func reset_selector() -> void:
	scale = Vector2(1,1);
	visible = false;
	selecting = false;
func start_selector() -> void:
	global_position = get_global_mouse_position();
	start_position = global_position;
	visible = true;
	selecting = true;
#endregion
#region Area2D Signals
func _enter_area(body):
	tracker.track(body);
func _exit_area(body):
	tracker.untrack(body);
#endregion
#region Enable/Disable
func enable() -> void:
	set_process_input(true);
	set_process_unhandled_input(true);
func disable() -> void:
	set_process_input(false);
	set_process_unhandled_input(false);
	visible = false;
#endregion
#region Action Button Callbacks
func _pressed_from_demolish():
	var duplicate : Array = selection.duplicate();
	for n in duplicate:
		var o = n.get_parent();
		if (o is Structure):
			if (o == base):
				print("%s | Cannot Demolish" % o.data.name);
				# TODO UI Notifications
				continue;
			o.queue_free();
			selection.erase(n);
			interact_menu.show_actions(selection);
#endregion
#region Filters
func get_units() -> Array:
	var array : Array = [];
	for n in selection:
		if (!is_instance_valid(n)): continue;
		var o = n.get_parent();
		if (o is Unit):
			array.push_back(o);
	return array;
func get_friendly_units() -> Array:
	var friendly : Array = [];
	for n in selection:
		if (!is_instance_valid(n)): continue;
		var o = n.get_parent();
		if (o.is_in_group(Common.group_friendly)):
			friendly.push_back(o);
	return friendly;
func get_structures() -> Array[Structure]:
	var array : Array[Structure] = [];
	for n in selection:
		if (!is_instance_valid(n)): continue;
		var o = n.get_parent();
		if (o is Structure):
			array.push_back(o);
	return array;
#endregion
