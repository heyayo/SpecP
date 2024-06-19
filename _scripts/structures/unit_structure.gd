extends Structure

class_name UnitStructure

@onready var training_timer = $"Training Timer"
@onready var game : Game = get_tree().root.get_node("Game");

@export var units : Array[PackedScene];

var queue : Array[Unit];

func _ready() -> void:
	super._ready();
	print("%s | Initializing Unit Structure" % name);
func finish() -> void:
	print("%s | Constructing Unit Structure" % name);

func queue_training(unit : Unit) -> void:
	print("%s | Queued Unit Training" % unit.object_data.name);
	if (queue.is_empty()):
		training_timer.wait_time = unit.training_time;
		training_timer.start();
	queue.push_back(unit);

func _timeout_from_training_timer():
	var unit : Unit = queue.front();
	print("%s | Finished Training" % unit.object_data.name);
	var dupe : Unit = unit.duplicate();
	game.spawn_unit(dupe);
	dupe.global_position = global_position;
	
	queue.remove_at(0);
	if (queue.is_empty()): return;
	training_timer.wait_time = queue.front().training_time;
	training_timer.start();
