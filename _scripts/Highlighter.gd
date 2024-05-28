extends Node2D

class_name Highlighter

var prefab : PackedScene = preload("res://_scenes/prefabs/highlight.tscn")

var highlights : Dictionary = {};

func highlight_structure(structure : Structure) -> void:
	# Spawn Highlight
	var h : Highlight = prefab.instantiate();
	add_child(h);
	h.global_position = structure.global_position;
	
	# Register
	highlights[structure] = h;

func remove_highlight_s(structure : Structure) -> void:
	highlights.erase(structure);
func remove_highlight_h(highlight : Highlight) -> void:
	highlights.erase(highlight.target);

func on_select(selection : Array) -> void:
	for s in selection:
		if (not s is Structure): continue;
		highlight_structure(s);
