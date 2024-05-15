extends Control

var _isPaused : bool = false;

func _ready():
	visible = _isPaused;

func _process(delta):
	if (Input.is_action_just_pressed("Pause")):
		_isPaused = !_isPaused;
		visible = _isPaused;
		get_tree().paused = _isPaused;
		pass
	pass


func _on_button_pressed():
	# TODO Replace with return to main menu
	# TODO Differentiate Buttons
	get_tree().quit();
	pass
