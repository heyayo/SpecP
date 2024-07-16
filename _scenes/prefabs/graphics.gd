extends VBoxContainer
class_name GraphicsControl

@onready var option_button : OptionButton = $OptionButton

func set_window_mode(index):
	match (index):
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
func _item_selected_from_option_button(index):
	set_window_mode(index);
