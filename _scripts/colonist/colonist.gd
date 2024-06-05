extends CharacterBody2D

class_name Colonist

@onready var nav_agent : C_Nav = $NavigationAgent2D;
@onready var anim : C_Anim = $AnimatedSprite2D;
@onready var tasker : Tasker = $Tasks;
@onready var detection : Detection = $"Interact Range";
@onready var timer : Timer = $Timer;
@onready var build_timer : Timer = $"Build Timer";
@onready var harvest_timer : Timer = $"Harvest Timer";

@export var speed : float = 50;

func _process(_delta) -> void:
	var status : bool = false;
	status = build_act();
	if (status) : return;
	status = harvest_act();
	if (status) : return;
	nav_agent.stop_path();
#region Task Acts
func build_act() -> bool:
	var a : Structure = tasker.get_closest_build();
	if (!a):
		tasker.remove_build_request(a);
		build_timer.stop();
		return false;
	var mark : ConstructionMark = a.get_construcion_mark();
	if (!mark):
		tasker.remove_build_request(a);
		build_timer.stop();
		return false;
	nav_agent.begin_path_to(a);
	if (detection.is_in_range(a)):
		if (build_timer.is_stopped()):
			build_timer.start();
			anim.interact();
			nav_agent.pause_path();
	return true;
func harvest_act() -> bool:
	var h : Harvestable = tasker.get_closest_harvest();
	if (!h):
		tasker.remove_harvest_request(h);
		harvest_timer.stop();
		return false;
	nav_agent.begin_path_to(h);
	if (detection.is_in_range(h)):
		if (harvest_timer.is_stopped()):
			harvest_timer.start();
			anim.interact();
			nav_agent.pause_path();
	return true;
#endregion

#region Natural Functions
func _physics_process(_delta):
	if (nav_agent.pathing):
		follow_path();
func stand_still() -> void:
	anim.direct(Vector2.ZERO);
	nav_agent.stop_path();
func follow_path() -> bool:
	if (nav_agent.is_navigation_finished()):
		anim.direct(Vector2.ZERO); # Make Animation Stand Still
		return false;
	var direction : Vector2 = (nav_agent.get_next_path_position() - global_position).normalized();
	if (!move(direction)): return true;
	var col = get_last_slide_collision();
	return true;
func move(direction : Vector2) -> bool:
	anim.direct(direction);
	velocity = direction * speed;
	return move_and_slide();
func tick_build(mark : ConstructionMark) -> void:
	mark.tick_progress(1); # TODO Colonist Build Skills
#endregion
#region Signals
func _on_build_timer_timeout():
	var build : Structure = tasker.get_closest_build();
	if (!build): return;
	var mark : ConstructionMark = build.get_construcion_mark();
	if (!mark): return;
	mark.tick_progress(1);
	nav_agent.resume_path();
func _on_harvest_timer_timeout():
	var harvest : Harvestable = tasker.get_closest_harvest();
	if (!harvest): return;
	harvest.tick_harvest(1);
	nav_agent.resume_path();
#endregion
