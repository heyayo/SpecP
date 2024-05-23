extends Node2D

class_name Colonist_StateMachine;

@onready var _controller : Colonist_Controller = get_parent();

func _process(_delta):
	if (_controller.manual): return;
