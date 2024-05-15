extends Node

var register : Dictionary;

func register_structure(tile_position : Vector2i, structure : Node) -> bool:
	if (register.has(tile_position)): return false;
	register[tile_position] = structure;
	return true;

func unregister_structure(tile_position : Vector2i) -> bool:
	if (register.has(tile_position)):
		register.erase(tile_position);
	return true;
