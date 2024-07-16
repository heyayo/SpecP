extends Node

#region Group Constants
const group_friendly : StringName = "Friendly";
const group_hostile : StringName = "Hostile";
const group_unit : StringName = "Unit";
const group_selectable : StringName = "Selectable";
const group_resource_structure : StringName = "ResourceStructure";
const group_persist : StringName = "persistent";
#endregion
#region Collision Layer Constants
const layer_selectable : int = 16;
const layer_structure : int = 15;
const layer_resource : int = 14;
const layer_unit : int = 13;
#endregion

#region Render Ordering
## Basic | 0
## Selector Highlight | 8
## Preview Sprite | 2
## Resource Sprite | 1
## Units | 4
## Resources and Structures | 3
#endregion

## ARRAY of All Structures in the game
var structures : Array[PackedScene] = [
	preload("res://_scenes/prefabs/structures/wood_mill.tscn"),
	preload("res://_scenes/prefabs/structures/mason_hut.tscn"),
	preload("res://_scenes/prefabs/structures/small_farm.tscn"),
	preload("res://_scenes/prefabs/structures/steel_mill.tscn"),
	preload("res://_scenes/prefabs/structures/ballista.tscn"),
	preload("res://_scenes/prefabs/structures/shock_tower.tscn"),
];

## Resource Types
enum RESOURCE_TYPE
{
	WOOD,
	FOOD,
	STONE,
	METAL
}
