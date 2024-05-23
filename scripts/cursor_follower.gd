extends Node2D

class_name Cursor_Follower;

@onready var building : StaticBody2D = $"..";
var builder_node : Builder = null;

const _goodColor = Color(0,1,0,0.5);
const _badColor = Color(1,0,0,0.5);

var _overlaps : Array;

func make(builder : Builder, size : Vector2):
	builder_node = builder;
	scale = size;

func _ready():
	building.modulate = _goodColor;

func _process(delta):
	if (Input.is_action_just_pressed("ui_accept")):
		print(_overlaps);
	building.global_position = builder_node._hoverPos;

func _on_body_entered(body):
	if (body == building): return;
	if (_overlaps.find(body) < 0):
		_overlaps.push_back(body);
	check_good_placement();

func _on_body_exited(body):
	if (body == building): return;
	var index : int = _overlaps.find(body);
	if (index < 0): return;
	_overlaps.remove_at(index);
	check_good_placement();

func check_good_placement():
	if (cannot_build()):
		building.modulate = _badColor;
	else: building.modulate = _goodColor;

func cannot_build() -> bool:
	return _overlaps.size() > 0;
