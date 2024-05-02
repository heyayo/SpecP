extends Camera2D

@export_category("ZOOM Controls")
@export var zoom_max : float = 4;
@export var zoom_min : float = 1;
@export var zoom_speed : float = 1;

@export_category("CAMERA Controls")
@export var cam_speed : float = 1;
@export var cam_speed_multiplier : float = 2;

var zoom_value : float = 1;

func _ready():
	zoom_value = zoom_min;
	zoom = Vector2(zoom_value,zoom_value);

func _process(delta):
	if (Input.is_action_pressed("ScrollIn") or Input.is_action_just_released("ScrollIn")):
		adjust_zoom(zoom_value);
	if (Input.is_action_pressed("ScrollOut") or Input.is_action_just_released("Scrol")):
		adjust_zoom(-zoom_value);
	
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
