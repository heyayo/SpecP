extends CharacterBody2D

class_name Colonist_Controller;

@onready var _worker : Worker = $Worker;
@onready var _sm : Colonist_StateMachine = $"State Machine";
@onready var _anim : Animator = $AnimatedSprite2D;
@onready var _camera : Camera_Controller = %"Game Camera";

@export_category("Manual Control Configuration")
@export var speed : float = 5;
@export var manual : bool = true :
	get: return manual;
	set(value):
		set_physics_process(value);
		set_process(value);
		manual = value;
		_camera.locked = value;
var _halt : bool = false;

func _process(_delta):
	_camera.global_position = global_position;
	if (Input.is_action_just_pressed("Interact") and not _halt):
		interact();

func _physics_process(_delta):
	if (_halt): return;
	var direction = Input.get_vector("LeftDir","RightDir","UpDir","DownDir");
	velocity = direction * speed;
	move_and_slide();
	_anim.direct(direction);

func interact():
	_halt = true;
	_anim.interact();
	_worker.interact();

func _on_animated_sprite_2d_animation_finished():
	_halt = false;

# TODO LIST
# Inventory System
# State Machine
