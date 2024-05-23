extends Node2D

class_name Build_Manager;

@onready var template : PackedScene = preload("res://buildings/structure.tscn");
@onready var construction_mark : PackedScene = preload("res://buildings/construction_mark.tscn");
@onready var cursor_follower : PackedScene = preload("res://buildings/cursor_follower.tscn");

@onready var preview : Area2D = $Preview;
@onready var preview_sprite : Sprite2D = $Preview/Sprite2D;
@onready var collision_shape : CollisionShape2D = $Preview/CollisionShape2D;

var good_color : Color = Color(0,1,0,0.5);
var bad_color : Color = Color(1,0,0,0.5);

func build_structure(structure : Construct, pos : Vector2i) -> void:
	var ns : Building = template.instantiate().make(structure);
	var mark : Construction_Mark = construction_mark.instantiate();
	ns.add_child(mark);
	add_child(ns);
	ns.global_position = pos;

func good() -> bool:
	return _overlaps.size() <= 0;

func preview_structure(structure : Construct) -> void:
	preview_sprite.texture = structure.texture;
	var size = 16 * structure.tile_size;
	var rect : RectangleShape2D = collision_shape.shape;
	size -= 1;
	rect.size = Vector2(size,size);
	preview.visible = true;
	collision_shape.set_deferred("disabled",false);

func end_preview() -> void:
	preview.visible = false;
	collision_shape.set_deferred("disabled",true);

func update_preview(pos : Vector2i):
	preview.global_position = pos;
	if (_overlaps.size()): preview_sprite.modulate = bad_color;
	else: preview_sprite.modulate = good_color;

func _ready():
	preview.visible = false;

#region Preview Collision Signals
var _overlaps : Array[Node2D] = [];

func preview_enter(body):
	if (_overlaps.find(body) >= 0): return;
	_overlaps.push_back(body);

func preview_exit(body):
	var index : int = _overlaps.find(body);
	if (index < 0): return;
	_overlaps.remove_at(index);
#endregion
