extends ColorRect

class_name Bills

#region Modules
@onready var selector : Selector = $"../../Selector"
@onready var menu_audio = $"../../MenuAudio"
#endregion

#region Preview
@onready var unit_name = $Preview/Title
@onready var unit_description = $Preview/Description
@onready var unit_preview = $Preview/Sprite
@onready var unit_origin = $Preview/Origin
#endregion
@onready var buttons = $Buttons/ScrollContainer/VBoxContainer
@onready var buttons_parent = $Buttons
@onready var unit_queue = $"Unit Queue"
@onready var template_icon = $"Unit Queue/HBoxContainer/Template Icon"
@onready var unit_queue_container = $"Unit Queue/HBoxContainer"

func _ready() -> void:
	disable();
	unit_name.text = "";
	unit_description.text = "";
	unit_origin.text = "";
	unit_preview.texture = null;
func _input(_event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		disable();

#region Bill
func clear_bills() -> void:
	for b in buttons.get_children():
		b.queue_free();
func build_bills(units : Array[PackedScene], origin : UnitStructure) -> void:
	for u in unit_queue_container.get_children():
		if (u == template_icon): continue;
		if u in queue_array: continue;
		u.queue_free();
	for u in units:
		var unit : Unit = u.instantiate();
		var b : Button = Button.new();
		b.text = unit.data.name;
		b.clip_text = true;
		buttons.add_child(b);
		b.custom_minimum_size = Vector2(buttons_parent.size.x,25);
		
		b.mouse_entered.connect(bill_hovered.bind(unit, origin));
		b.pressed.connect(bill_pressed.bind(unit, origin));
		b.pressed.connect(menu_audio.button_pressed_two);
var queue_array : Array[UnitQueueIcon] = [];
func build_queue(unit : Unit) -> UnitQueueIcon:
	var nicon : UnitQueueIcon = template_icon.duplicate();
	unit_queue_container.add_child(nicon);
	queue_array.push_back(nicon);
	nicon.visible = true;
	nicon.unit_name.text = unit.data.name;
	return nicon;
#endregion
#region Signal Callbacks
func bill_hovered(unit : Unit, origin : UnitStructure) -> void:
	unit_name.text = unit.data.name;
	unit_description.text = unit.data.desc;
	unit_origin.text = "Originates From\n%s" % origin.data.name;
	if (unit.data.preview != null):
		unit_preview.texture = unit.data.preview;
	else:
		unit_preview.texture = unit.get_node("Animator").get_preview_texture();
func bill_pressed(unit : Unit, origin : UnitStructure) -> void:
	origin.queue_training(unit);
	var nicon = build_queue(unit);
func trained() -> void:
	var a = queue_array.front();
	a.queue_free();
	queue_array.erase(a);
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
#endregion

func _pressed_from_bills():
	if (visible):
		disable();
		return;
	enable();
	clear_bills();
	var selection = selector.selection;
	for n in selection:
		var o = n.get_parent();
		if (o is UnitStructure):
			var unit_struct : UnitStructure = o as UnitStructure;
			build_bills(unit_struct.units, unit_struct);
