extends CanvasLayer
class_name LoadingScreen

static var scene : String;
static var loading_scene = preload("res://_scenes/loading_screen.tscn");
@onready var animation_player = $Control/AnimationPlayer

func _ready() -> void:
	ResourceLoader.load_threaded_request(scene);
	#animation_player.play("Loading");

func _process(_delta):
	var progress : Array = [];
	var status := ResourceLoader.load_threaded_get_status(scene, progress);
	if (status == ResourceLoader.THREAD_LOAD_LOADED):
		var load = ResourceLoader.load_threaded_get(scene);
		get_tree().change_scene_to_packed(load);
