extends Area2D

class_name Selectable

signal sig_enable;
signal sig_disable;

func _ready() -> void:
	collision_layer = 0;
	collision_mask = 0;
	set_collision_layer_value(Common.layer_selectable,true);
	print("%s | Initializing Selectable" % get_parent().name);
	disable();

#region Enable/Disable
func enable() -> void:
	visible = true;
	sig_enable.emit();
func disable() -> void:
	visible = false;
	sig_disable.emit();
#endregion
