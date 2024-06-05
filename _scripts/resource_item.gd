extends Area2D

class_name ResourceItem

var data : Item;
var stack : int = 1;

@onready var sprite : Sprite2D = $Sprite2D;

func make(blueprint : Item) -> ResourceItem:
	data = blueprint;
	return self;

func _ready():
	sprite.texture = data.sprite;
