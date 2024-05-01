extends Node2D

@onready var highlight_sprite : Sprite2D = $Highlight;
@onready var select_sprite : Sprite2D = $Select;

@onready var hasSelected : bool = false;

func _ready():
	select_sprite.visible = hasSelected;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_position = get_global_mouse_position();
	var hover_pos = floor(mouse_position / 16) * 16;
	hover_pos += Vector2(8,8);
	highlight_sprite.global_position = hover_pos;
	
	left_click_handle(hover_pos);
	right_click_handle();
	
	pass

func select_tile(tile : Vector2):
	# TODO Check if select tile is valid (in bounds)
	select_sprite.global_position = tile;
	hasSelected = true;
	pass

func left_click_handle(select_position : Vector2):
	if (Input.is_action_just_pressed("Left_Click")):
		hasSelected = true;
		select_sprite.visible = hasSelected;
		select_sprite.global_position = select_position;
		pass
	pass

func right_click_handle():
	if (Input.is_action_just_pressed("Right_Click")):
		if hasSelected:
			hasSelected = false;
			select_sprite.visible = hasSelected;
			pass
		pass
	pass
