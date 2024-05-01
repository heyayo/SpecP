extends Control

var isPaused : bool = false;

func _ready():
	visible = isPaused;

func _process(delta):
	if (Input.is_action_just_pressed("Pause")):
		isPaused = !isPaused;
		visible = isPaused;
		get_tree().paused = isPaused;
		pass
	pass


func _on_button_pressed():
	# TODO Replace with return to main menu
	get_tree().quit();
	pass
