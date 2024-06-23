extends Node2D

class_name Overseer

@onready var click_detect : Area2D = $"Click Detect"

var units : Array[Unit];
var detect : Tracker = Tracker.new();

func _process(_delta) -> void:
	click_detect.global_position = get_global_mouse_position();
func _input(_event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		var target : Unit = is_over_hostile();
		if (target != null):
			print("Attacking Unit");
			attack_units(target);
		else:
			print("Moving Units");
			move_units();

func move_units() -> void:
	#get_tree().call_group(Common.group_controllable,"move_unit",get_global_mouse_position());
	var dead : Array[Unit] = [];
	for u : Unit in units:
		if (!is_instance_valid(u)):
			dead.push_back(u);
			continue;
		u.move_to(get_global_mouse_position());
	for d in dead:
		units.erase(d);
func attack_units(target : Unit) -> void:
	for u : Unit in units:
		u.force_attack(target); ## TODO Normal Attack
func is_over_hostile() -> Unit:
	for u in detect.collection:
		if (u is Unit and !u.is_in_group(Common.group_friendly)):
			return u;
			break;
	return null;

func _body_entered_from_click_detect(body):
	detect.track(body);
func _body_exited_from_click_detect(body):
	detect.untrack(body);
