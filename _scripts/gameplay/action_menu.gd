extends Control

class_name ActionsMenu

#region External
@export var builder : Builder;
@export var resources : MResource;
#endregion
@onready var scroll_con = $ScrollContainer;
@onready var vbox : VBoxContainer = $ScrollContainer/VBoxContainer;
@onready var name_label : Label = $Name;
@onready var desc_label : Label = $Description;
@onready var sprite_textrect : TextureRect = $"Structure Preview";
@onready var costs_label : Label = $Costs;

func _ready():
	fill_actions();
	visible = false;
	cost_preview(0,0,0);
func _input(_event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		disable();
## Create Buttons to initiate Building Structures
func fill_actions() -> void:
	for c in Common.structures:
		var wo : Structure = c.instantiate();
		var button : Button = Button.new();
		button.text = wo.name;
		button.clip_text = true;
		vbox.add_child(button);
		button.custom_minimum_size = Vector2(scroll_con.size.x,25);
		
		# Signals
		button.mouse_entered.connect(hover_details.bind(wo)); ## Display Structure on Hover
		button.pressed.connect(action_pressed.bind(wo)); ## Send Build Request onclick
#region Action Button Callbacks
func hover_details(object : Structure) -> void:
	## Sets Identification Labels
	name_label.text = object.object_data.name;
	desc_label.text = object.object_data.desc;
	cost_preview(object.wood,object.food,object.stone); ## Sets Cost Label
	sprite_preview(object);
func action_pressed(object : Structure) -> void:
	# TODO UI for deny
	if (not cost_check(object)): return; ## Denies Build Request if they cannot afford it
	builder.start_preview(object); ## Begins Build Request
	visible = false; ## Hides Menu
func cost_check(structure : Structure) -> bool:
	if (structure.wood > resources.wood): return false;
	if (structure.food > resources.food): return false;
	if (structure.stone > resources.stone): return false;
	return true;
# TODO Fourth Resource
func cost_preview(wood : int, food: int, stone: int) -> void:
	costs_label.text = "
	Wood: %s
	Food: %s
	Stone: %s
	" % [wood,food,stone];
func sprite_preview(structure : Structure) -> void:
	var sprite : Texture = structure.get_node("Sprite2D").texture;
	sprite_textrect.texture = sprite;
#endregion

#region Enable/Disable
func enable() -> void:
	set_process(true);
	set_process_input(true);
	visible = true;
func disable() -> void:
	set_process(false);
	set_process_input(false);
	visible = false;
func toggle() -> void:
	visible = !visible;
	set_process(visible);
	set_process_input(visible);
#endregion
