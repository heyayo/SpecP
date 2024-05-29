extends Area2D

class_name Selector

signal sig_select(selection : Array);
signal sig_deselect;

var tracker : Tracker = Tracker.new();

func _ready() -> void:
	visible = false;
func _input(event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Left_Click")):
		global_position = get_global_mouse_position();
		start_position = global_position;
		visible = true;
		sig_deselect.emit(); ## Deselect previous selection
	if (Input.is_action_just_released("Left_Click")):
		sig_select.emit(tracker.collection);
		visible = false;
	if (Input.is_action_pressed("Left_Click")):
		resize_selector();

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

#region Area2D Signals
func _enter_area(body):
	tracker.track(body);
func _exit_area(body):
	tracker.untrack(body);
#endregion

#region Expose
func enable() -> void:
	set_process_input(true);
func disable() -> void:
	set_process_input(false);
	visible = false;
#endregion
