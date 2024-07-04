extends Control
class_name Notifier

@onready var container = $VBoxContainer
@onready var template_label = $"VBoxContainer/Template Label"

func notify(message : String) -> void:
	var label : Label = template_label.duplicate();
	label.text = message;
	var timer : Timer = label.get_node("Timer");
	timer.timeout.connect(notification_end.bind(label));
	label.visible = true;
	container.add_child(label);
	timer.start();

func notification_end(label : Label) -> void:
	label.queue_free();
