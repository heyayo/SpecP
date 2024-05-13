extends Node2D

class_name Builder;

enum ACTIONS {
	BUILD,
	ZONE,
	NONE
}

@onready var _highlightSprite : Sprite2D = $Highlight;
@onready var _selectSprite : Sprite2D = $Select;
@onready var _buildMenu : Control = $"Menu/Build Menu";
@onready var _infoPanel : Info_Panel = $"Menu/Info Panel";
@onready var _tileMap : TileMap = get_tree().root.get_node("World");
@onready var _spaceChecker : Area2D = $"Space Checker"
@onready var _spaceCheckerSize : CollisionShape2D = $"Space Checker/CollisionShape2D";

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
	if (Input.is_action_just_pressed("Right_Click")):
		right_click_handle();
	pass;

func _unhandled_input(event):
	if (Input.is_action_just_pressed("Left_Click")):
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
	pass

func deselect_tile() -> void:
	hasSelected = false;
	_selectSprite.visible = hasSelected;
	_infoPanel.visible = false;

# Checks if there is space for building
func space_check(require : int, hover_pos : Vector2i) -> bool:
	_spaceCheckerSize.scale = Vector2(require,require);
	_spaceChecker.global_position = hover_pos;
	var bodies = _spaceChecker.get_overlapping_bodies();
	return bodies.is_empty();

#region Click Handles
func left_click_handle(hover_pos : Vector2i, tile_pos : Vector2i) -> void:
	match (_cAction):
		ACTIONS.BUILD:
			var structure : Building = _structure.prefab.instantiate();
			if (!space_check(structure.tile_size,hover_pos)): # FIXME Does not properly detect building colliders
				print("Building Overlaps Existing Building");
				structure.free();
				return;
			get_tree().root.add_child(structure);
			structure.global_position = hover_pos;
			stop_action();
			pass;
		ACTIONS.ZONE:
			# TODO Add Zoning Action
			pass;
		_: # Default Case
			select_tile(hover_pos, tile_pos);
			_buildMenu.visible = false;
			pass;

func right_click_handle() -> void:
	_buildMenu.visible = false;
	if (hasSelected):
		deselect_tile(); # Disable Selection Overlay and Build Menu
		pass
	elif (_cAction != ACTIONS.NONE):
		stop_action();
		pass
	pass
#endregion

#region Signals
func _on_buildings_pressed():
	_buildMenu.visible = true;
	deselect_tile();
	pass # Replace with function body.

func _on_actions_item_selected(index):
	
	pass # Replace with function body.
#endregion
