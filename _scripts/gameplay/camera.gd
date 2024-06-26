extends Camera2D

class_name Camera

@export_category("Zoom")
@export var min_zoom : float = 1;
@export var max_zoom : float = 5;
@export var step_zoom : float = 0.25;
@export_category("Movement")
@export var speed : float = 5;

func _ready() -> void:
	adjust_zoom_fixed(min_zoom);
func _unhandled_input(event) -> void:
	if (event.is_action_released("Zoom_In")):
		adjust_zoom_relative(step_zoom);
	if (event.is_action_released("Zoom_Out")):
		adjust_zoom_relative(-step_zoom);
func _process(_delta):
	var move_dir : Vector2 = Input.get_vector("Left","Right","Up","Down");
	global_position += move_dir * speed;

func adjust_zoom_relative(step : float) -> void:
	zoom += Vector2(step,step);
	zoom = clamp(zoom,Vector2(min_zoom,min_zoom), Vector2(max_zoom,max_zoom));
func adjust_zoom_fixed(value : float) -> void:
	zoom = Vector2(value,value);
	zoom = clamp(zoom,Vector2(min_zoom,min_zoom), Vector2(max_zoom,max_zoom));
