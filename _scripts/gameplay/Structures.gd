extends Node2D

class_name Structure_Manager

signal sig_add_structure(s : Structure);

var prefab : PackedScene = preload("res://_scenes/prefabs/structure.tscn");
var con_mark : PackedScene = preload("res://_scenes/prefabs/construction_mark.tscn");

func add_structure(structure : Construct) -> Structure:
	var s : Structure = prefab.instantiate().make(structure);
	add_child(s);
	sig_add_structure.emit(s);
	return s;

func remove_structure(structure : Structure) -> void:
	structure.queue_free();

func mark_construction(structure : Structure) -> void:
	var mark : ConstructionMark = con_mark.instantiate().make(structure.data);
	structure.add_child(mark);

#region Signals
func callback_construct(structure : Construct, location : Vector2i) -> void:
	var s : Structure = add_structure(structure);
	s.global_position = location;
	mark_construction(s);
	print("Constructing at %s" % location);
func callback_construct_instant(structure : Construct, location : Vector2i) -> void:
	var s : Structure = add_structure(structure);
	s.global_position = location;
	s.construct();
	print("Constructing Instant at %s" % location);
#endregion
