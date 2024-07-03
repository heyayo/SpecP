extends Node2D
class_name DefensiveStructure

@export var projectile : PackedScene;
@export var damage : int = 10;
@onready var sprite_2d : AnimatedSprite2D = $"../Sprite2D";
@onready var game : Game = $"/root/Game";
@onready var range : Detection = $Range
@onready var parent : Structure = get_parent();
@onready var timer : Timer = $Timer
var unit : Unit = null;

func _ready() -> void:
	disable();
func shoot() -> void:
	if (!is_instance_valid(unit)): return;
	parent.look_at(unit.global_position);
	sprite_2d.play("shoot");
	var dupe : Projectile = projectile.instantiate();
	dupe.setup(damage,unit,self);
	game.add_child(dupe);
	dupe.global_position = global_position;
func _process(_delta) -> void:
	if (range.is_empty()): return;
	var target = range.has_group_node(Common.group_hostile);
	if (!is_instance_valid(target)): return;
	unit = target;
	if (timer.is_stopped()):
		timer.start();

func enable() -> void:
	set_process(true);
func disable() -> void:
	set_process(false);

## For compatiblity
func report_death(target) -> void:
	pass
