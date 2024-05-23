extends Control

@onready var _builder : Builder = $"../..";
@onready var _options : Panel = $Options;
@onready var _actions : VBoxContainer = $Options/Actions/Contents
@onready var _desc : Label = $Options/Description
@onready var _bname : Label = $Options/Name
@onready var _preview : TextureRect = $Options/Preview;

# TODO Check if a prefab is needed instead of a normal node creation
var _buttonPrefab : PackedScene = preload("res://scenes/ui_components/action_button.tscn");

func _ready():
	construct_buildings();
	
	# Clear out the Labels
	_bname.text = "";
	_desc.text = "";
	pass;

# TODO Make Buttons expand to fit parent
func construct_buildings() -> void:
	for data : Construct in Common.Buildings:
		var button : Button = _buttonPrefab.instantiate();
		button.text = data.structure_name;
		_actions.add_child(button);
		button.connect("pressed",build_callback.bind(data));
		button.connect("mouse_entered",hover_callback.bind(data));

func build_callback(building : Construct) -> void:
	_builder.start_build_action(building);
	visible = false;
	print_rich("[color=pink]Button Called Back[/color]");

func hover_callback(c : Construct) -> void:
	_bname.text = c.structure_name;
	_desc.text = c.structure_description;
	_preview.texture = c.texture;
