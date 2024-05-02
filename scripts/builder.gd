extends Node2D

@onready var _highlightSprite : Sprite2D = $Highlight;
@onready var _selectSprite : Sprite2D = $Select;
@onready var _buildMenu : Control = $"Menu/Build Menu";
@onready var _infoPanel : Info_Panel = $"Menu/Info Panel";
var _tileMap : TileMap;

@onready var hasSelected : bool = false;

const _tileSize : int = 16;

func _ready():
    _selectSprite.visible = hasSelected;
    _tileMap = get_tree().root.get_node("Test_Map");
    _infoPanel.visible = false;

func _process(delta):
    var mouse_position : Vector2 = get_global_mouse_position();
    var tile_pos : Vector2i = _tileMap.local_to_map(to_local(mouse_position)); # Was floor(mouse_position / 16), local_to_map takes into account of tile size
    var hover_pos : Vector2i = tile_pos * _tileSize;
    hover_pos += Vector2i(8,8);
    _highlightSprite.global_position = hover_pos;
    
    left_click_handle(hover_pos, tile_pos);
    right_click_handle();
    
    pass;

# Places tile highlight at selection point
func select_tile(hover_pos : Vector2, tile_pos) -> void:
    # TODO Check if select tile is valid (in bounds)
    hasSelected = true;
    _selectSprite.visible = hasSelected;
    _selectSprite.global_position = hover_pos;
    _infoPanel.display_tile(_tileMap.get_cell_tile_data(0,tile_pos));
    pass

func deselect_tile() -> void:
    hasSelected = false;
    _selectSprite.visible = hasSelected;
    _infoPanel.visible = false;
    pass

func left_click_handle(hover_pos : Vector2, tile_pos : Vector2) -> void:
    if (Input.is_action_just_pressed("Left_Click")):
        select_tile(hover_pos, tile_pos);
        _buildMenu.visible = false;
        # TODO Remove current action
        pass
    pass

func right_click_handle() -> void:
    if (Input.is_action_just_pressed("Right_Click")):
        if hasSelected:
            # Disable Selection Overlay and Build Menu
            deselect_tile();
            pass
        else:
            _buildMenu.visible = !_buildMenu.visible;
            pass
        pass
    pass
