extends Control

class_name ActionsMenu

#region External
@export var builder : Builder;
@export var resources : MResource;
@onready var notification = $"../Notification"
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
	cost_preview(StructureData.new());
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
func hover_details(structure : Structure) -> void:
	## Sets Identification Labels
	name_label.text = structure.data.name;
	desc_label.text = structure.data.desc;
	cost_preview(structure.data); ## Sets Cost Label
	sprite_preview(structure);
func action_pressed(object : Structure) -> void:
	if (not cost_check(object)):
		notification.notify("Not enough resources");
		return; ## Denies Build Request if they cannot afford it
	builder.start_preview(object); ## Begins Build Request
	visible = false; ## Hides Menu
func cost_check(structure : Structure) -> bool:
	var cost : StructureData = structure.data;
	if (cost.wood > resources.wood): return false;
	if (cost.food > resources.food): return false;
	if (cost.stone > resources.stone): return false;
	if (cost.metal > resources.metal): return false;
	return true;
func cost_preview(costs : StructureData) -> void:
	costs_label.text = "
	Wood: %s
	Food: %s
	Stone: %s
	Metal: %s
	" % [costs.wood,costs.food,costs.stone,costs.metal];
func sprite_preview(structure : Structure) -> void:
	var sprite = structure.get_node("Sprite2D");
	var preview_texture : Texture;
	if (sprite is Sprite2D):
		preview_texture = sprite.texture;
		sprite_textrect.texture = preview_texture;
		return;
	if (sprite is AnimatedSprite2D):
		var asp : AnimatedSprite2D = sprite as AnimatedSprite2D;
		preview_texture = asp.sprite_frames.get_frame_texture("default",0);
		sprite_textrect.texture = preview_texture;
		return;
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
