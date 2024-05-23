extends Node

var group_construction : String = "In_Construction";
var group_structure : String = "Structure";

var cLayer_buildings : int = 0b00000000_00000000_00000000_00000001;

var Buildings : Array[Construct] = [
	preload("res://buildings/data/Small Home.tres"),
	preload("res://buildings/data/Campsite.tres")
];
