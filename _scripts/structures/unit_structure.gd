extends Structure
class_name UnitStructure

signal sig_kill_icon;

@onready var game : Game = get_tree().root.get_node("Game");
@onready var resources : MResource = $"../Resources"
@onready var unit_signal : ColorRect = $Signal
@onready var selectable : Selectable = $Selectable
@onready var notifier : Notifier= $"../Interface/Notification"

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
func queue_training(unit : Unit) -> bool:
	if (!cost_check(unit.data)):
		notifier.notify("Not enough resources to train");
		return false;
	game.adjust_resources(0,-unit.data.food,0,-unit.data.metal);
	if (queue.is_empty()):
		training_timer.wait_time = unit.data.training_time;
		training_timer.start();
	queue.push_back(unit);
	unit_signal.color = Color.GREEN;
	
	print("%s | Queued Unit Training" % unit.data.name);
	return true;
func cost_check(data : UnitStats) -> bool:
	if (data.food > resources.food): return false;
	if (data.metal > resources.metal): return false;
	return true;

## Function for spawning units
func _timeout_from_training_timer():
	var unit : Unit = queue.front();
	var dupe : Unit = unit.duplicate();
	game.spawn_friendly(dupe);
	dupe.global_position = global_position;
	
	sig_kill_icon.emit();
	queue.remove_at(0);
	if (queue.is_empty()):
		unit_signal.color = Color.RED;
		return;
	training_timer.wait_time = queue.front().data.training_time;
	training_timer.start();
	unit_signal.color = Color.GREEN;
	
	print("%s | Finished Training" % unit.data.name);
