extends AnimatedSprite2D

class_name Animator

@onready var body : Unit = get_parent();

enum ANIMS
{
	idle,
	walk,
	attack
}
var c_anim : ANIMS = ANIMS.idle;
var attacking : bool = false;

func _ready() -> void:
	animation = "idle";
func _process(_delta) -> void:
	var v : Vector2 = body.velocity;
	flip_h = false if v.x > 0 else true;
	if (attacking): return;
	if (v):
		set_anim(ANIMS.walk);
	else:
		set_anim(ANIMS.idle);
func set_anim(animation : ANIMS) -> void:
	play(ANIMS.keys()[animation]);
func attack() -> void:
	attacking = true;
	set_anim(ANIMS.attack);
func reset() -> void:
	var v : Vector2 = body.velocity;
	if (v):
		set_anim(ANIMS.walk);
	else:
		set_anim(ANIMS.idle);
	attacking = false;
func get_preview_texture() -> Texture:
	var texture : Texture = sprite_frames.get_frame_texture("idle",0);
	return texture;

func _on_animation_finished():
	attacking = false;
