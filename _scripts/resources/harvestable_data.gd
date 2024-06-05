extends Resource

class_name HarvestableData

@export_category("Identification")
@export var name : String = "HARVESTABLE";
@export var desc : String = "ENTER DESCRIPTION";

@export_category("Blueprint")
@export var drops : Array[ResourceDrop];
@export var sprite : Texture;
@export var size : Vector2i;
@export var resource_health : int;
