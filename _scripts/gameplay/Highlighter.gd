extends Node2D

class_name Highlighter

const ratio : float = 1.0/72.0;
var prefab : PackedScene = preload("res://_scenes/prefabs/highlight.tscn")

#region LEGACY
#func callback_harvestables_remove(harvest):
	#remove_highlight_key(harvest);
#func highlight_structure(structure : Structure) -> void:
	## Spawn Highlight
	#var h : Highlight = prefab.instantiate();
	#h.target = structure;
	#h.resize(structure.data.tile_size);
	#add_child(h);
	#h.global_position = structure.global_position;
	#print(h.scale);
	#
	## Register
	#highlights[structure] = h;
#
#func highlight_colonist(colonist : Colonist) -> void:
	#var h : Highlight = prefab.instantiate();
	#h.target = colonist;
	#h.resize(1);
	#add_child(h);
	#
	## Register
	#highlights[colonist] = h;
#
#func highlight_harvestable(harvestable : Harvestable) -> void:
	#var h : Highlight = prefab.instantiate();
	#h.target = harvestable;
	#h.resize_v(harvestable.data.size);
	#add_child(h);
	#
	#highlights[harvestable] = h;
#endregion
#region Lookup
var highlights : Dictionary = {};
func remove_highlight_key(key : Node2D) -> void:
	highlights[key].queue_free();
	highlights.erase(key);
func remove_highlight_val(highlight : Highlight) -> void:
	highlights[highlight.target].queue_free();
	highlights.erase(highlight.target);
#endregion

func callback_select(selection : Array) -> void:
	for h in highlights:
		highlights[h].queue_free();
	highlights.clear();
	print(selection);
	for s in selection:
		var h : Highlight = prefab.instantiate();
		h.target = s;
		h.resize_v(s.tile_size);
		add_child(h);
		highlights[s] = h;
