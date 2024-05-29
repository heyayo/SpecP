extends Control

class_name Actions_Menu

signal sig_on_toggle(status : bool);
signal sig_action_pressed(structure : Construct);

@onready var scroll_con = $ScrollContainer;
@onready var vbox : VBoxContainer = $ScrollContainer/VBoxContainer;
@onready var name_label : Label = $Name;
@onready var desc_label : Label = $Description;

func _ready():
	fill_actions();
	visible = false;

func fill_actions() -> void:
	for c in Common.structures:
		var button : Button = Button.new();
		button.text = c.name;
		button.clip_text = true;
		vbox.add_child(button);
		button.custom_minimum_size = Vector2(scroll_con.size.x,25);
		
		# Signals
		button.mouse_entered.connect(hover_details_callback.bind(c)); ## Display Structure on Hover
		button.pressed.connect(callback_action_pressed.bind(c)); ## Send Build Request onclick

func hover_details_callback(structure : Construct) -> void:
	name_label.text = structure.name;
	desc_label.text = structure.desc;

#region Enable/Disable
func enable() -> void:
	visible = true;
func disable() -> void:
	visible = false;
func toggle() -> void:
	visible = !visible;
	sig_on_toggle.emit(visible);
#endregion

#region Signals
func callback_action_pressed(structure : Construct) -> void:
	sig_action_pressed.emit(structure);
	visible = false;
#endregion
