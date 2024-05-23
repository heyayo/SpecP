extends Node2D

class_name Work_Target;

var callback : Callable;

func make(c : Callable) -> Work_Target:
	callback = c;
	return self;
