extends Node2D

class_name Builder

var con_mark : PackedScene = preload("res://_scenes/prefabs/construction_mark.tscn")

#region Children
@onready var preview_area : Area2D = $PreviewArea
@onready var preview_sprite : Sprite2D = $PreviewArea/PreviewSprite
@onready var preview_shape : CollisionShape2D = $PreviewArea/PreviewShape
@onready var resource_area = $ResourceArea
@onready var resource_shape = $ResourceArea/ResourceShape
#endregion
#region External
@export var selector : Selector;
@export var game : Game;
#endregion

var preview_track : Tracker = Tracker.new();
var resource_track : Tracker = Tracker.new();
var to_build : Structure = null;
# TODO Display Requirements UI
var req_range : int;
var req_types : Array[Common.RESOURCE_TYPE];

func _ready() -> void:
	stop_preview();
	disable();
func _process(_delta) -> void:
	update_preview_position();
	update_resource_position();
func _input(_event : InputEvent) -> void:
	if (Input.is_action_just_pressed("Right_Click")):
		stop_preview();
	if (Input.is_action_just_pressed("Left_Click")):
		if (not preview_track.collection.is_empty()): return;
		place_building();
	if (Input.is_action_just_released("Left_Click")):
		call_deferred("stop_preview");
func place_building() -> void: ## Places the building in the world and begins its construction
	var b : Structure = to_build.duplicate();
	add_child(b);
	b.global_position = game.get_hover_position();
	## Add Construction Mark
	var mark : ConstructionMark = con_mark.instantiate();
	mark.cost = b.work_cost;
	b.add_child(mark);
	## Resource Building Signal Connection
	if (b is ResourceStructure):
		var res_struct : ResourceStructure = b as ResourceStructure;
		res_struct.sig_harvest.connect(game.give_resource);
	## Deduct Resources
	game.adjust_resources(-b.wood,-b.food,-b.stone);
#region Preview Functions
func start_preview(building : Structure) -> void: ## Prepare the Build Preview
	selector.disable(); ## Disable Selector
	to_build = building; ## Sets Global Build Object
	## Set Preview Texture
	var bSprite : Sprite2D = building.get_node("Sprite2D");
	preview_sprite.texture = bSprite.texture;
	## Set Preview Collision Size
	var shape : RectangleShape2D = preview_shape.shape;
	var size : Vector2i = bSprite.texture.get_size();
	size -= Vector2i(1,1);
	shape.size = size;
	## Make Preview Visible and Sets Initial Color
	preview_area.visible = true;
	resource_area.visible = true;
	update_preview_modulation();
	## Enables Builder Functions
	enable();
func stop_preview() -> void:
	selector.enable(); ## Enable Selector
	to_build = null; ## NULLs Global Build Object
	preview_area.visible = false; ## Hides Preview Sprite
	resource_area.visible = false;
	disable();
func update_preview_modulation() -> void:
	preview_sprite.modulate = Color.GREEN if preview_track.collection.is_empty() else Color.RED;
func update_resource_modulation() -> void:
	if (req_range > 0):
		preview_sprite.modulate = Color.GREEN if not resource_track.collection.is_empty() else Color.RED;
func update_preview_position() -> void:
	preview_area.global_position = game.get_hover_position();
func update_resource_position() -> void:
	resource_area.global_position = game.get_hover_position();
#endregion
#region Enable/Disable
func enable() -> void:
	set_process(true);
	set_process_input(true);
func disable() -> void:
	set_process(false);
	set_process_input(false);
#endregion
#region Signal Callbacks
func _enter_preview(node) -> void:
	preview_track.track(node);
	update_preview_modulation();
func _exit_preview(node) -> void:
	preview_track.untrack(node);
	update_preview_modulation();
func _area_entered_from_resource_area(area):
	resource_track.track(area);
	update_resource_modulation();
func _area_exited_from_resource_area(area):
	resource_track.untrack(area);
	update_resource_modulation();
#endregion
