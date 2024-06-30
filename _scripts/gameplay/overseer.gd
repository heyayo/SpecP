extends Node2D

class_name Overseer

@onready var click_detect : Area2D = $"Click Detect"
@onready var interact_menu = $"../Interface/Interact Menu"

var units : Array;
var detect : Tracker = Tracker.new();

func _process(_delta) -> void:
	click_detect.global_position = get_global_mouse_position();
func _input(_event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		var target = is_over_hostile_unit();
		if (target != null):
			attack_units(target);
		else:
			target = is_over_hostile_structure();
			if (target != null):
				attack_units(target);
			else:
				move_units();
	## Unit Behaviour Settings
	if (Input.is_action_just_pressed("Set Passive")):
		set_behaviour(Unit.BEHAVIOUR.PASSIVE);
	if (Input.is_action_just_pressed("Set Defensive")):
		set_behaviour(Unit.BEHAVIOUR.DEFENSIVE);
	if (Input.is_action_just_pressed("Set Aggressive")):
		set_behaviour(Unit.BEHAVIOUR.AGGRESSIVE);

func set_behaviour(behaviour : Unit.BEHAVIOUR) -> void:
	for u in units:
		u.behaviour = behaviour;
	interact_menu.show_unit_info(units);
func move_units() -> void:
	var dead : Array[Unit] = [];
	for u in units:
		if (!is_instance_valid(u)):
			dead.push_back(u);
			continue;
		u.move_action(get_global_mouse_position());
		#u.stop_move_to(get_global_mouse_position());
	for d in dead:
		units.erase(d);
func attack_units(target) -> void:
	if (!is_instance_valid(target)): return;
	for u in units:
		u.attack_action(target);
func is_over_hostile_unit() -> Unit:
	for u in detect.collection:
		if (u is Unit and !u.is_in_group(Common.group_friendly)):
			return u;
	return null;
func is_over_hostile_structure() -> Structure:
	for s in detect.collection:
		if (s is Structure and s.is_in_group(Common.group_hostile)):
			return s;
	return null;

func _body_entered_from_click_detect(body):
	detect.track(body);
func _body_exited_from_click_detect(body):
	detect.untrack(body);
