extends Node2D

class_name Builder;

enum ACTIONS {
	BUILD,
	ZONE,
	NONE
}

var _cursorFollower : PackedScene = preload("res://buildings/cursor_follower.tscn");
var _constructionMark : PackedScene = preload("res://buildings/construction_mark.tscn");

@onready var _buildMenu : Control = $"Menu/Build Menu";
@onready var _infoPanel : Info_Panel = $"Menu/Info Panel";
@onready var _highlightSprite : Sprite2D = $Highlight;
@onready var _dragSelector : Selector = $Selector;
@onready var _buildingManager : Build_Manager = $"../Building Manager"
@onready var _tileMap : TileMap = get_tree().root.get_node("World");

var _cAction : ACTIONS = ACTIONS.NONE;
var hasSelected : bool = false;
var _structure : Construct;

const _tileSize : int = 16;

var _hoverPos : Vector2i; # The center of the tile hovered by the mouse
var _tilePos : Vector2i; # The position of the mouse on the TileMap

#region GODOT Callbacks
func _ready():
	_infoPanel.visible = false;
	_buildMenu.visible = false;
	hasSelected = false;
	
	_dragSelector.disable();

func _process(delta):
	# Click Processing
	var mouse_position : Vector2 = get_global_mouse_position();
	_tilePos = _tileMap.local_to_map(to_local(mouse_position)); # Was floor(mouse_position / 16), local_to_map takes into account of tile size
	_hoverPos = _tilePos * _tileSize;
	_hoverPos += Vector2i(8,8);
	_highlightSprite.global_position = _hoverPos;
	if (Input.is_action_just_pressed("Right_Click")):
		right_click_handle();
	if (Input.is_action_just_released("Left_Click")):
		left_drag_end_handle();
	if (Input.is_action_pressed("Left_Click") and hasSelected):
		left_drag_handle();
	_buildingManager.update_preview(_hoverPos);

func _unhandled_input(event):
	if (Input.is_action_just_pressed("Left_Click")):
		left_click_handle(_hoverPos, _tilePos);
#endregion

#region ACTION Functions
func start_action(type : ACTIONS) -> void:
	deselect_tile();
	_cAction = type;

func stop_action() -> void:
	_cAction = ACTIONS.NONE;
	_buildingManager.end_preview();

func start_build_action(structure : Construct) -> void:
	_cAction = ACTIONS.BUILD;
	_buildingManager.preview_structure(structure);
	_structure = structure;

func do_build_action() -> void:
	_buildingManager.build_structure(_structure, Vector2i(0,0));
#endregion

#region Tile Select Functions
func select_tile(hover_pos : Vector2, tile_pos) -> void:
	_dragSelector.begin_selection(get_global_mouse_position());
	_dragSelector.enable();
	
	hasSelected = true;
	var data : TileData = _tileMap.get_cell_tile_data(0,tile_pos);
	if (data == null):
		print("Attempting to Access NULL Tile | Out of Bounds?");
		return;
	_infoPanel.display_tile(data);

func deselect_tile() -> void:
	hasSelected = false;
	_infoPanel.visible = false;
#endregion

#region Click Handles
func left_click_handle(hover_pos : Vector2i, tile_pos : Vector2i) -> void:
	deselect_tile();
	_highlightSprite.visible = false;
	match (_cAction):
		ACTIONS.BUILD:
			if (_buildingManager.good()):
				_buildingManager.build_structure(_structure,hover_pos);
				stop_action();
		ACTIONS.ZONE:
			# TODO Add Zoning Action
			pass;
		_: # Default Case
			select_tile(hover_pos, tile_pos);
			_buildMenu.visible = false;

func right_click_handle() -> void:
	_buildMenu.visible = false;
	if (hasSelected):
		deselect_tile(); # Disable Selection Overlay and Build Menu
	elif (_cAction != ACTIONS.NONE):
		stop_action();

func left_drag_handle() -> void:
	_dragSelector.do_selection(get_global_mouse_position());

func left_drag_end_handle() -> void:
	_dragSelector.highlight_selection();
	_dragSelector.disable();
	_highlightSprite.visible = true;
#endregion

#region Signals
func _on_buildings_pressed():
	_buildMenu.visible = true;
	deselect_tile();
#endregion