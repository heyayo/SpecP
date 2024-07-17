extends Node2D

class_name Overseer

@onready var click_detect : Area2D = $"Click Detect"
@onready var interact_menu = $"../Interface/Interact Menu"
@onready var camera_2d = $"../Camera2D"
@onready var menu_audio = $"../MenuAudio"

var units : Array;
var detect : Tracker = Tracker.new();

func _process(_delta) -> void:
	click_detect.global_position = get_global_mouse_position();
func _input(_event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		var target = is_over_hostile_unit();
		if (is_instance_valid(target)):
			attack_units(target);
			menu_audio.attack_action();
		else:
			target = is_over_hostile_structure();
			if (is_instance_valid(target)):
				attack_units(target);
				menu_audio.attack_action();
			else:
				move_units();
				menu_audio.move_action();
	## Unit Behaviour Settings
	if (Input.is_action_just_pressed("Set Passive")):
		set_behaviour(Unit.BEHAVIOUR.PASSIVE);
		print_rich("[color=blue]Switched To Passive[/color]")
	if (Input.is_action_just_pressed("Set Defensive")):
		set_behaviour(Unit.BEHAVIOUR.DEFENSIVE);
		print_rich("[color=yellow]Switched To Defensive[/color]")
	if (Input.is_action_just_pressed("Set Aggressive")):
		set_behaviour(Unit.BEHAVIOUR.AGGRESSIVE);
		print_rich("[color=red]Switched To Aggressive[/color]")
	if (Input.is_action_just_pressed("Center Camera")):
		center_camera();
	#if (Input.is_action_just_pressed("Find Boss")):
		#boss_finder.point_nearest();

func center_camera() -> void:
	if (units.is_empty() or units.size() > 1):
		camera_2d.global_position = Vector2(0,0);
		return;
	camera_2d.global_position = units.front().global_position;
func set_behaviour(behaviour : Unit.BEHAVIOUR) -> void:
	for u in units:
		if (!is_instance_valid(u)): continue; ## lazy
		u.behaviour = behaviour;
	interact_menu.show_unit_info(units);
	menu_audio.behaviour_action();
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
	var dead : Array[Unit] = [];
	for u in units:
		if (!is_instance_valid(u)):
			dead.push_back(u);
			continue;
		u.attack_action(target);
	for d in dead:
		units.erase(d);
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
