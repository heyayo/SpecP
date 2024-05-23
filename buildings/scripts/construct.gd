extends Resource

class_name Construct;

@export_category("Factory Settings")
@export var structure_name : String; ## Name of the Structure
@export_multiline var structure_description : String; ## Description of the Structure
@export var tile_size : int; # Size of Structure in Tiles (16px)
@export var texture : Texture2D; # Structure Texture
@export var script_type : Script;

@export_category("Costs")
@export var build_cost : int; ## Amount of work needed to build
# TODO Implement resource cost for building
