extends CanvasLayer
class_name PauseMenu

@onready var options = $Options

func _input(event):
	if (Input.is_action_just_pressed("ui_cancel")):
		visible = !visible;
		get_tree().paused = !get_tree().paused;

#region Button Callbacks
func callback_resume_game():
	visible = false;
	get_tree().paused = false;
func _pressed_from_options():
	visible = false;
	options.visible = true;
	options.sync_config();
func callback_save_game():
	var persist = get_tree().get_nodes_in_group(Common.group_persist);
	var data = SaveLoader.save_game(persist);
	var status = SaveLoader.save_file(data);
	if (!status):
		printerr("Failed to save game data");
		return;
	print("Saved Game Data");
func callback_quit_menu():
	get_tree().paused = false;
	LoadingScreen.scene = "res://_scenes/main_menu.tscn"
	get_tree().change_scene_to_packed(LoadingScreen.loading_scene);
func _pressed_from_options_back():
	options.visible = false;
	visible = true;
	options.no_save();
func _pressed_from_apply():
	options.visible = false;
	visible = true;
	options.apply_settings();
#endregion
