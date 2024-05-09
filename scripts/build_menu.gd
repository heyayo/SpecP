extends Control

@onready var _builder : Builder = $"../..";
@onready var _options : Panel = $Options;
@onready var _actions : VBoxContainer = $Options/Actions/Contents
@onready var _desc : Label = $Options/Description
@onready var _bname : Label = $Options/Name
# TODO Preview Picture

var _buttonPrefab : PackedScene = preload("res://scenes/ui_components/action_button.tscn");

func _ready():
	construct_buildings();
	pass;

# TODO Make Buttons expand to fit parent
func construct_buildings() -> void:
	var buildings_num : int = Tile_Database.BUILDINGS_LIST.size();
	for i in range(buildings_num):
		var data : Tile_Database.Structure = Tile_Database.BUILDINGS_LIST[i];
		var button : Button = _buttonPrefab.instantiate();
		button.text = data.bname;
		_actions.add_child(button);
		button.connect("pressed",build_callback.bind(data));
		pass
	pass;

func build_callback(building : Tile_Database.Structure) -> void:
	_builder.start_build_action(building);
	print("Button Called Back");
	pass
