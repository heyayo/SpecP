extends Structure
class_name UnitStructure

@onready var game : Game = get_tree().root.get_node("Game");
@onready var unit_signal : ColorRect = $Signal
@onready var selectable : Selectable = $Selectable

@export var units : Array[PackedScene];

var queue : Array[Unit];
var training_timer : Timer;

func _init() -> void:
	training_timer = Timer.new();
	training_timer.one_shot = true;
	add_child(training_timer);
func _ready() -> void:
	super._ready();
	training_timer.timeout.connect(_timeout_from_training_timer);
	print("%s | Initializing Unit Structure" % name);
	unit_signal.color = Color.RED;
	selectable.sig_enable.connect(func(): unit_signal.visible = true);
	selectable.sig_disable.connect(func(): unit_signal.visible = false);
func finish() -> void:
	print("%s | Constructing Unit Structure" % name);
func queue_training(unit : Unit) -> void:
	if (queue.is_empty()):
		training_timer.wait_time = unit.data.training_time;
		training_timer.start();
	queue.push_back(unit);
	unit_signal.color = Color.GREEN;
	
	print("%s | Queued Unit Training" % unit.data.name);

## Function for spawning units
func _timeout_from_training_timer():
	var unit : Unit = queue.front();
	var dupe : Unit = unit.duplicate();
	game.spawn_friendly(dupe);
	dupe.global_position = global_position;
	
	queue.remove_at(0);
	if (queue.is_empty()):
		unit_signal.color = Color.RED;
		return;
	training_timer.wait_time = queue.front().data.training_time;
	training_timer.start();
	unit_signal.color = Color.GREEN;
	
	print("%s | Finished Training" % unit.data.name);
