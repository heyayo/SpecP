extends Sprite2D

class_name SpritePreview

@onready var shape : RectangleShape2D = $Area2D/CollisionShape2D.shape;
@onready var game : Game = get_tree().root.get_node("Game");

var tracker : Tracker = Tracker.new();

func _process(_delta) -> void:
	global_position = game.get_hover_position();

#region Enable/Disable
func enable() -> void:
	visible = true;
	set_process(true);
func disable() -> void:
	visible = false;
	set_process(false);
#endregion

func resize_area(size : int) -> void:
	var s = 16 * size;
	shape.size = Vector2(s,s);
func update_modulate() -> void:
	modulate = Color(0,1,0,0.5) if tracker.collection.is_empty() else Color(1,0,0,0.5);

func _on_area_2d_body_entered(body):
	tracker.track(body);
	update_modulate();

func _on_area_2d_body_exited(body):
	tracker.untrack(body);
	update_modulate();
