extends Resource

class_name Construct

@export_category("Identification")
@export var name : String = "NONAME";
@export_multiline var desc : String = "FILL IN DESCRIPTION";

@export_category("Blueprint")
@export var tile_size : int = 1;
@export var sprite : Texture = null;
@export var work_cost : int = 1;
