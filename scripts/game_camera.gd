extends Camera2D

class_name Camera_Controller;

@export_category("ZOOM Controls")
@export var zoom_max : float = 4;
@export var zoom_min : float = 1;
@export var zoom_speed : float = 1;
@export var zoom_scroll : float = 5;

@export_category("CAMERA Controls")
@export var cam_speed : float = 1;
@export var cam_speed_multiplier : float = 2;

var zoom_value : float = 1;
var locked : bool = false;

func _ready():
	zoom_value = (zoom_max - zoom_min) / 2;
	zoom = Vector2(zoom_value,zoom_value);

func _process(delta):
	if (Input.is_action_just_released("ScrollIn")):
		adjust_zoom(zoom_value * zoom_scroll);
	if (Input.is_action_just_released("ScrollOut")):
		adjust_zoom(-zoom_value * zoom_scroll);
	if (Input.is_action_pressed("ZoomIn")):
		adjust_zoom(zoom_value);
	if (Input.is_action_pressed("ZoomOut")):
		adjust_zoom(-zoom_value);
	
	if (locked): return;
	var adjusted_speed = cam_speed * delta / zoom_value;
	if (Input.is_action_pressed("Sprint")):
		adjusted_speed *= cam_speed_multiplier;
	if (Input.is_action_pressed("UpDir")):
		global_position.y -= adjusted_speed;
	if (Input.is_action_pressed("DownDir")):
		global_position.y += adjusted_speed;
	if (Input.is_action_pressed("LeftDir")):
		global_position.x -= adjusted_speed;
	if (Input.is_action_pressed("RightDir")):
		global_position.x += adjusted_speed;

func adjust_zoom(diff : float):
	zoom_value += diff * get_process_delta_time();
	zoom_value = clamp(zoom_value,zoom_min,zoom_max);
	zoom = Vector2(zoom_value,zoom_value);
