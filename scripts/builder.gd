extends Node2D

class_name Builder;

enum ACTIONS {
	BUILD,
	ZONE,
	NONE
}

var building_prefab : PackedScene = preload("res://scenes/building.tscn");

@onready var _highlightSprite : Sprite2D = $Highlight;
@onready var _selectSprite : Sprite2D = $Select;
@onready var _buildMenu : Control = $"Menu/Build Menu";
@onready var _infoPanel : Info_Panel = $"Menu/Info Panel";
@onready var _tileMap : TileMap = get_tree().root.get_node("World");

var _cAction : ACTIONS = ACTIONS.NONE;
var _structure : Tile_Database.Structure;

var hasSelected : bool = false;

const _tileSize : int = 16;

var _hoverPos : Vector2i; # The center of the tile hovered by the mouse
var _tilePos : Vector2i; # The position of the mouse on the TileMap

func _ready():
	_selectSprite.visible = hasSelected;
	_infoPanel.visible = false;
	_buildMenu.visible = false;
	hasSelected = false;

func _process(delta):
	# Click Processing
	var mouse_position : Vector2 = get_global_mouse_position();
	_tilePos = _tileMap.local_to_map(to_local(mouse_position)); # Was floor(mouse_position / 16), local_to_map takes into account of tile size
	_hoverPos = _tilePos * _tileSize;
	_hoverPos += Vector2i(8,8);
	_highlightSprite.global_position = _hoverPos;
	right_click_handle();
	pass;

func _unhandled_input(event):
	# Key Inputs
	left_click_handle(_hoverPos, _tilePos);
	pass

func start_action(type : ACTIONS) -> void:
	deselect_tile();
	_cAction = type;
	pass

func stop_action() -> void:
	_cAction = ACTIONS.NONE;
	pass

func start_build_action(structure : Tile_Database.Structure):
	_cAction = ACTIONS.BUILD;
	_structure = structure;
	pass

# Places tile highlight at selection point
func select_tile(hover_pos : Vector2, tile_pos) -> void:
	# TODO Check if select tile is valid (in bounds)
	hasSelected = true;
	_selectSprite.visible = hasSelected;
	_selectSprite.global_position = hover_pos;
	var data : TileData = _tileMap.get_cell_tile_data(0,tile_pos);
	if (data == null):
		print("Attempting to Access NULL Tile | Out of Bounds?");
		return;
	_infoPanel.display_tile(data);
	pass

func deselect_tile() -> void:
	hasSelected = false;
	_selectSprite.visible = hasSelected;
	_infoPanel.visible = false;
	pass

func left_click_handle(hover_pos : Vector2i, tile_pos : Vector2i) -> void:
	if (Input.is_action_just_pressed("Left_Click")):
		match (_cAction):
			ACTIONS.BUILD:
				# TODO Spawn Building Prefab with Pattern
				_tileMap.set_pattern(WORLD_MAP.Layers.Structure,tile_pos,_structure.pattern);
				stop_action();
				pass;
			ACTIONS.ZONE:
				# TODO
				pass;
			_: # Default Case
				select_tile(hover_pos, tile_pos);
				_buildMenu.visible = false;
				pass;
	pass

func right_click_handle() -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		_buildMenu.visible = false;
		if (hasSelected):
			deselect_tile(); # Disable Selection Overlay and Build Menu
			pass
		elif (_cAction != ACTIONS.NONE):
			stop_action();
			pass
		pass
	pass


func _on_buildings_pressed():
	_buildMenu.visible = true;
	deselect_tile();
	pass # Replace with function body.

func _on_actions_item_selected(index):
	
	pass # Replace with function body.
