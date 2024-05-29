extends Node2D

class_name Actioner

@onready var preview : SpritePreview = $Preview;

func start_construction(structure : Construct) -> void:
	setup_preview(structure);
	preview.enable();

func setup_preview(structure : Construct) -> void:
	preview.texture = structure.sprite;
	preview.resize_area(structure.tile_size);
	preview.update_modulate();

#region Signals
func callback_action_pressed(structure : Construct):
	start_construction(structure);
#endregion
