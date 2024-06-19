extends Area2D

class_name Selector

#region External
@export var interact_menu : InteractMenu;
@export var bills : Bills;
@export var overseer : Overseer;
#endregion
@onready var base = $"../Base"

var tracker : Tracker = Tracker.new();
var persist : Tracker = Tracker.new();
var selecting : bool = false;
# FIXME Selection Glitches | Selection sometimes unresponsive, demolish button double takes
func _ready() -> void:
	visible = false;
func _input(_event : InputEvent) -> void:
	if (Input.is_action_pressed("Left_Click") and selecting):
		resize_selector();
func _unhandled_input(_event : InputEvent) -> void:
	if (Input.is_action_just_released("Left_Click")):
		persist.collection = tracker.collection.duplicate();
		highlight_selected();
		visible = false;
		selecting = false;
		reset_selector();
		interact_menu.show_actions(persist.collection);
		overseer.units = get_units();
	if (Input.is_action_just_pressed("Left_Click")):
		clear_highlights();
		persist.collection.clear();
		visible = true;
		selecting = true;
		start_selector();
		interact_menu.hide_actions();
#region Highlighting
func highlight_selected() -> void:
	for n : Selectable in persist.collection:
		n.enable();
func clear_highlights() -> void:
	for n : Selectable in persist.collection:
		n.disable();
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
func start_selector() -> void:
	global_position = get_global_mouse_position();
	start_position = global_position;
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
	var duplicate : Array = persist.collection.duplicate();
	for n in duplicate:
		var o = n.get_parent();
		if (o is Structure):
			if (o == base):
				print("%s | Cannot Demolish" % o.object_data.name);
				# TODO UI Notifications
				continue;
			o.queue_free();
			persist.collection.erase(n);
			interact_menu.show_actions(persist.collection);
func _pressed_from_bills():
	if (bills.visible):
		bills.disable();
		return;
	bills.enable();
	bills.clear_bills();
	for n in persist.collection:
		var o = n.get_parent();
		if (o is UnitStructure):
			var unit_struct : UnitStructure = o as UnitStructure;
			bills.build_bills(unit_struct.units, unit_struct);
#endregion
#region Filters
func get_units() -> Array[Unit]:
	var array : Array[Unit] = [];
	for n in persist.collection:
		var o = n.get_parent();
		if (o is Unit):
			array.push_back(o);
	return array;
func get_structures() -> Array[Structure]:
	var array : Array[Structure] = [];
	for n in persist.collection:
		var o = n.get_parent();
		if (o is Structure):
			array.push_back(o);
	return array;
#endregion
