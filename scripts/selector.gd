extends Area2D

class_name Selector;

@onready var _collection : Node2D = $"../Highlights";
@onready var _highlight : Sprite2D = $"../Highlight";
@onready var _collision_shape : CollisionShape2D = $"Selection Area";

var start_position : Vector2;

var selection : Array:
	get: return selection;

func _ready():
	enable();

func enable():
	visible = true;
	_collision_shape.set_deferred("disabled", false);

func disable():
	visible = false;
	_collision_shape.set_deferred("disabled", true);

func begin_selection(start : Vector2) -> void:
	global_position = start;
	start_position = start;
	selection.clear();
	for s in _collection.get_children():
		s.queue_free();

func do_selection(hover : Vector2) -> void:
	var distance : Vector2 = hover - start_position;
	scale = Vector2(distance/16);
	global_position = start_position + distance/2;

func highlight_selection() -> void:
	print("Selected Count %s" % selection.size());
	for s : Building in selection:
		var dupe = _highlight.duplicate();
		_collection.add_child(dupe);
		dupe.global_position = s.global_position;
		var hsize = s.tile_size * 0.25;
		dupe.scale = Vector2(hsize,hsize);
		dupe.visible = true;

func _on_body_entered(body):
	#print("Selected %s" % body);
	if (selection.find(body) >= 0): return;
	selection.push_back(body);

func _on_body_exited(body):
	#print("Deselected %s" % body);
	var index : int = selection.find(body);
	if (index < 0): return;
	selection.remove_at(index);
