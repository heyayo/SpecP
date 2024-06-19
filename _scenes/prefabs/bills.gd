extends ColorRect

class_name Bills

#region Preview
@onready var unit_name = $Preview/Title
@onready var unit_description = $Preview/Description
@onready var unit_preview = $Preview/Sprite
@onready var unit_origin = $Preview/Origin
#endregion
@onready var buttons = $Buttons/ScrollContainer/VBoxContainer
@onready var buttons_parent = $Buttons

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
	for u in units:
		var unit : Unit = u.instantiate();
		var b : Button = Button.new();
		b.text = unit.object_data.name;
		b.clip_text = true;
		buttons.add_child(b);
		b.custom_minimum_size = Vector2(buttons_parent.size.x,25);
		
		b.mouse_entered.connect(bill_hovered.bind(unit, origin));
		b.pressed.connect(bill_pressed.bind(unit, origin));
#endregion
#region Signal Callbacks
func bill_hovered(unit : Unit, origin : UnitStructure) -> void:
	unit_name.text = unit.object_data.name;
	unit_description.text = unit.object_data.desc;
	unit_origin.text = "Originates From\n%s" % origin.object_data.name;
	unit_preview.texture = unit.get_node("Sprite2D").texture;
func bill_pressed(unit : Unit, origin : UnitStructure) -> void:
	origin.queue_training(unit);
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
