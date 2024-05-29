extends Node2D

class_name Structure_Manager

var structure_prefab : PackedScene = preload("res://_scenes/prefabs/structure.tscn");

func add_structure(structure : Construct) -> Structure:
	var s : Structure = structure_prefab.instantiate().make(structure);
	return s;

func remove_structure(structure : Structure) -> void:
	pass;
