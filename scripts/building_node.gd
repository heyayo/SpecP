extends Node2D

class_name Builder;

enum ACTIONS {
	BUILD,
	ZONE,
	NONE
}

var _cursorFollower : PackedScene = preload("res://buildings/cursor_follower.tscn");
var _constructionMark : PackedScene = preload("res://buildings/construction_mark.tscn");

@onready var _highlightSprite : Sprite2D = $Highlight;
@onready var _selectSprite : Sprite2D = $Select;
@onready var _dragSelection : ColorRect = $DragSelection;
@onready var _buildMenu : Control = $"Menu/Build Menu";
@onready var _infoPanel : Info_Panel = $"Menu/Info Panel";
@onready var _tileMap : TileMap = get_tree().root.get_node("World");

var _cAction : ACTIONS = ACTIONS.NONE;
var hasSelected : bool = false;
var isDragging : bool = false;

#region BUILD Action Variables
var _structure : Tile_Database.Structure;
var _activeStructure : Building;
var _follower : Cursor_Follower;
#endregion
#region ZONE Action Variables

#endregion
#region DRAG Handle Variables
var _originalPosition : Vector2i;
var _originalTilePosition : Vector2i;
var _collectedStructures : Array;
#endregion

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
	if (Input.is_action_just_pressed("Right_Click")):
		right_click_handle();
	if (Input.is_action_just_released("Left_Click")):
		left_drag_end_handle();
	if (Input.is_action_pressed("Left_Click") and hasSelected):
		left_drag_handle();

func _unhandled_input(event):
	if (Input.is_action_just_pressed("Left_Click")):
		left_click_handle(_hoverPos, _tilePos);

#region ACTION Functions
func start_action(type : ACTIONS) -> void:
	deselect_tile();
	_cAction = type;

func stop_action() -> void:
	_cAction = ACTIONS.NONE;
	_structure = null;
	if (_activeStructure != null):
		_activeStructure.queue_free();
		_activeStructure = null;

func start_build_action(structure : Tile_Database.Structure):
	_cAction = ACTIONS.BUILD;
	_structure = structure;
	_activeStructure = _structure.prefab.instantiate();
	get_tree().root.add_child(_activeStructure);
	_follower = _cursorFollower.instantiate();
	_activeStructure.add_child(_follower);
	_follower.builder_node = self;
	_follower.scale = Vector2(_activeStructure.tile_size,_activeStructure.tile_size);

func do_build_action() -> void:
	_activeStructure.add_child(_constructionMark.instantiate());
	_activeStructure.get_node("Cursor Follower").queue_free();
	_activeStructure.modulate = Color(1,1,1,1);
	_activeStructure.global_position = _hoverPos;
	var structure_tile = _tileMap.local_to_map(_activeStructure.global_position);
	WorldStorage.register_structure(structure_tile,_activeStructure);
	print("Structure Built on %s" % structure_tile);
	_activeStructure = null;
	_follower = null;
#endregion

#region Tile Select Functions
func select_tile(hover_pos : Vector2, tile_pos) -> void:
	# TODO Intercept Buildings
	hasSelected = true;
	_selectSprite.visible = hasSelected;
	_selectSprite.global_position = hover_pos;
	var data : TileData = _tileMap.get_cell_tile_data(0,tile_pos);
	if (data == null):
		print("Attempting to Access NULL Tile | Out of Bounds?");
		return;
	_infoPanel.display_tile(data);

func deselect_tile() -> void:
	hasSelected = false;
	isDragging = false;
	_selectSprite.scale = Vector2(.25,.25);
	_selectSprite.visible = hasSelected;
	_dragSelection.visible = false;
	_infoPanel.visible = false;

func do_drag(distance : Vector2i) -> void:
	isDragging = true;
	# FIXME Does not appear properly in opposite directions
	_dragSelection.visible = true;
	_dragSelection.global_position = _originalPosition - Vector2i(8,8);
	_dragSelection.scale = distance + Vector2i(1,1);

func stop_drag() -> void:
	isDragging = false;
	_dragSelection.visible = false;
#endregion

func collect_dragged() -> void:
	var dir : int = 0;
	if ((_tilePos - _originalTilePosition).length() > 0): dir = 1;
	else: dir = -1;
	for x in range(_originalTilePosition.x,_tilePos.x + dir):
		for y in range(_originalTilePosition.y,_tilePos.y + dir):
			if (WorldStorage.register.has(Vector2i(x,y))):
				_collectedStructures.push_back(WorldStorage.register.get(Vector2i(x,y)));

#region Click Handles
func left_click_handle(hover_pos : Vector2i, tile_pos : Vector2i) -> void:
	_originalPosition = _hoverPos;
	_originalTilePosition = _tilePos;
	#print("Tile Position: %s" % _tilePos);
	#print("Hover Position: %s" % _hoverPos);
	#print("Tile Position C: %s" % _tileMap.local_to_map(_hoverPos));
	#print("Hover Position C: %s" % Common.tile_to_hover(_tilePos));
	deselect_tile();
	match (_cAction):
		ACTIONS.BUILD:
			if (_activeStructure != null):
				if (!_follower.cannot_build()):
					do_build_action();
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
	var distance := (_hoverPos - _originalPosition) / 16;
	if (distance.x == 0 and distance.y == 0): return;
	do_drag(distance);

func left_drag_end_handle() -> void:
	stop_drag();
	_collectedStructures.clear();
	collect_dragged();
	print(_collectedStructures);
#endregion

#region Signals
func _on_buildings_pressed():
	_buildMenu.visible = true;
	deselect_tile();
#endregion
