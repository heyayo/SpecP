extends Node2D

func _ready():
	get_tree().call_group(Common.group_structure,"construct");
