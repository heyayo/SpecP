extends Node

#region Group Constants
const group_structure : StringName = "Structure";
const group_construction : StringName = "Construction";
const group_resource : StringName = "Resource";
const group_faction_friendly : StringName = "FN Friendly";
const group_faction_wild : StringName = "FN Wild";
const group_faction_bandit : StringName = "FN Bandit"
#endregion
#region Collision Layer Constants
const layer_selectable : int = 16;
const layer_structure : int = 15;
const layer_resource : int = 14;
const layer_unit : int = 13;
#endregion

## ARRAY of All Structures in the game
var structures : Array[PackedScene] = [
	preload("res://_scenes/prefabs/structures/base.tscn"),
	preload("res://_scenes/prefabs/structures/wood_mill.tscn"),
	preload("res://_scenes/prefabs/structures/mason_hut.tscn")
];

## Resource Types
enum RESOURCE_TYPE
{
	WOOD,
	FOOD,
	STONE,
	# TODO Fourth Resource
}
