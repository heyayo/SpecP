extends Control
class_name HealthBar

@onready var missing_health_bar = $"Missing Health"
@onready var health_bar = $Health

func update_bar(health : float, max_health : float) -> void:
	var percentage : float = health / max_health;
	health_bar.scale = Vector2(percentage,1);
