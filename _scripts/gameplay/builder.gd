extends Node2D

class_name Builder
## TODO Prevent Out of Bounds Building
var con_mark : PackedScene = preload("res://_scenes/prefabs/construction_mark.tscn")

#region Children
@onready var preview_area : Area2D = $PreviewArea
@onready var preview_sprite : Sprite2D = $PreviewArea/PreviewSprite
@onready var preview_shape : CollisionShape2D = $PreviewArea/PreviewShape
@onready var resource_area = $ResourceArea
@onready var resource_shape = $ResourceArea/ResourceShape
@onready var resource_sprite = $ResourceArea/ResourceSprite
#endregion
#region External
@export var selector : Selector;
@export var game : Game;
#endregion

var preview_track : Tracker = Tracker.new();
var resource_track : Tracker = Tracker.new();
var to_build : Structure = null;
var is_obstructed : bool = false;

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
		if (not is_obstructed): return;
		place_building();
	#if (Input.is_action_just_released("Left_Click")):
		#call_deferred("stop_preview");
func place_building() -> void: ## Places the building in the world and begins its construction
	var b : Structure = to_build.duplicate();
	add_child(b);
	b.global_position = game.get_hover_position();
	## Add Construction Mark
	var mark : ConstructionMark = con_mark.instantiate();
	mark.cost = b.data.work;
	b.add_child(mark);
	## Resource Building Signal Connection
	if (b is ResourceStructure):
		var res_struct : ResourceStructure = b as ResourceStructure;
		res_struct.sig_harvest.connect(game.give_resource);
	## Deduct Resources
	game.adjust_structure_cost(b.data);
#region Preview Functions
func start_preview(building : Structure) -> void: ## Prepare the Build Preview
	selector.disable(); ## Disable Selector
	to_build = building; ## Sets Global Build Object
	## Set Preview Texture
	var bSprite : Sprite2D = building.get_node("Sprite2D");
	preview_sprite.texture = bSprite.texture;
	resize_preview(bSprite.texture.get_size());
	## Make Preview Visible and Sets Initial Color
	preview_area.visible = true;
	## Resource Structure Preview
	if (building is ResourceStructure):
		var res_struct : ResourceStructure = building;
		resource_area.visible = true;
		resize_resource_preview(res_struct.stats.rangevec2(),bSprite.texture.get_size());
	update_preview_modulation();
	enable();
func stop_preview() -> void:
	selector.enable(); ## Enable Selector
	to_build = null; ## NULLs Global Build Object
	preview_area.visible = false; ## Hides Preview Sprite
	resource_area.visible = false;
	disable();
#endregion
#region Preview Preparation
func resize_preview(size : Vector2i) -> void:
	var shape : RectangleShape2D = preview_shape.shape;
	size -= Vector2i(1,1);
	shape.size = size;
func resize_resource_preview(size : Vector2i, structure_size : Vector2i) -> void:
	var shape : RectangleShape2D = resource_shape.shape;
	size *= 16;
	size += structure_size;
	shape.size = size;
	resource_sprite.scale = size;
#endregion
#region Modulation
func update_preview_modulation() -> void:
	var have_resources : bool = false;
	if (to_build is ResourceStructure):
		var count : int = 0;
		for res in resource_track.collection:
			if (not res is WorldResource):
				break;
			var resource : WorldResource = res;
			if (resource.type == to_build.stats.type):
				count += 1;
				if (count >= to_build.stats.required_amount):
					have_resources = true;
					break;
	is_obstructed = preview_track.collection.is_empty() and have_resources;
	preview_sprite.modulate = Color.GREEN if is_obstructed else Color.RED;
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
	update_preview_modulation();
func _area_exited_from_resource_area(area):
	resource_track.untrack(area);
	update_preview_modulation();
#endregion
