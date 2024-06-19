extends AnimatedSprite2D

## Attached to a Worker's AnimatedSprite2D
class_name CAnim;

enum ANIMATIONS
{
	south,
	south_west,
	west,
	north_west,
	north,
	north_east,
	east,
	south_east,
	still,
	interact
}

const threshold : float = 0.5;
var cur_anim : ANIMATIONS = ANIMATIONS.still :
	get: return cur_anim;
	set(value):
		cur_anim = value;
		play(ANIMATIONS.keys()[value]);
var still_dir : ANIMATIONS = ANIMATIONS.south;

func interact() -> void:
	cur_anim = ANIMATIONS.interact;

const _h : float = 0.4142;
func direct(direction : Vector2) -> void:
	var pure_x : float = absf(direction.x);
	var pure_y : float = absf(direction.y);
	if (pure_x < 0.1 && pure_y < 0.1):
		cur_anim = ANIMATIONS.still;
		frame = still_dir;
		return;
	if (pure_x > pure_y):
		var half : float = pure_x * _h;
		if (direction.x < 0):
			if (direction.y > half):
				cur_anim = ANIMATIONS.south_west;
				still_dir = ANIMATIONS.south_west;
				return;
			if (direction.y < -half):
				cur_anim = ANIMATIONS.north_west;
				still_dir = ANIMATIONS.north_west;
				return;
			cur_anim = ANIMATIONS.west;
			still_dir = ANIMATIONS.west;
			return;
		else:
			if (direction.y > half):
				cur_anim = ANIMATIONS.south_east;
				still_dir = ANIMATIONS.south_east;
				return;
			if (direction.y < -half):
				cur_anim = ANIMATIONS.north_east;
				still_dir = ANIMATIONS.north_east;
				return;
			cur_anim = ANIMATIONS.east;
			still_dir = ANIMATIONS.east;
			return;
	else:
		var half : float = pure_y * _h;
		if (direction.y > 0):
			if (direction.x > half):
				cur_anim = ANIMATIONS.south_east;
				still_dir = ANIMATIONS.south_east;
				return;
			if (direction.x < -half):
				cur_anim = ANIMATIONS.south_west;
				still_dir = ANIMATIONS.south_west;
				return;
			cur_anim = ANIMATIONS.south;
			still_dir = ANIMATIONS.south;
			return;
		else:
			if (direction.x > half):
				cur_anim = ANIMATIONS.north_east;
				still_dir = ANIMATIONS.north_east;
				return;
			if (direction.x < -half):
				cur_anim = ANIMATIONS.north_west;
				still_dir = ANIMATIONS.north_west;
				return;
			cur_anim = ANIMATIONS.north;
			still_dir = ANIMATIONS.north;
			return;
