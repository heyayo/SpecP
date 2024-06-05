extends Node2D

class_name Actioner

signal sig_start;
signal sig_stop;
signal sig_construct(structure : Construct, location : Vector2i);

@onready var game : Game = get_tree().root.get_node("Game");
@onready var preview : SpritePreview = $Preview;

var active_construction : Construct = null;

func _input(event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Left_Click")):
		if (!active_construction): return;
		if (!preview.good()): return;
		construct(active_construction);
	if (Input.is_action_just_released("Left_Click")):
		stop_construction();

func start_construction(structure : Construct) -> void:
	sig_start.emit();
	active_construction = structure;
	setup_preview(structure);
	preview.enable();
	set_process_input(true);
func stop_construction() -> void:
	call_deferred("emit_sigstop");
	active_construction = null;
	preview.disable();
	set_process_input(false);
func emit_sigstop() -> void:
	sig_stop.emit();

func setup_preview(structure : Construct) -> void:
	preview.texture = structure.sprite;
	preview.resize_area(structure.tile_size);
	preview.update_modulate();

func construct(structure : Construct) -> void:
	sig_construct.emit(structure, game.get_hover_position());

#region Signals
func callback_action_pressed(structure : Construct): ## Action Menu Button
	start_construction(structure);
#endregion
