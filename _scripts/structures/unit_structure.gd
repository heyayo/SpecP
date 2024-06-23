extends Structure
class_name UnitStructure

@onready var game : Game = get_tree().root.get_node("Game");

@export var units : Array[PackedScene];

var queue : Array[Unit];
var training_timer : Timer;

func _init() -> void:
	training_timer = Timer.new();
	add_child(training_timer);
func _ready() -> void:
	super._ready();
	training_timer.timeout.connect(_timeout_from_training_timer);
	print("%s | Initializing Unit Structure" % name);
func finish() -> void:
	print("%s | Constructing Unit Structure" % name);

func queue_training(unit : Unit) -> void:
	if (queue.is_empty()):
		training_timer.wait_time = unit.stats.training_time;
		training_timer.start();
	queue.push_back(unit);
	
	print("%s | Queued Unit Training" % unit.data.name);

## Function for spawning units
func _timeout_from_training_timer():
	var unit : Unit = queue.front();
	var dupe : Unit = unit.duplicate();
	game.spawn_friendly(dupe);
	dupe.global_position = global_position;
	
	queue.remove_at(0);
	if (queue.is_empty()): return;
	training_timer.wait_time = queue.front().training_time;
	training_timer.start();
	
	print("%s | Finished Training" % unit.data.name);
