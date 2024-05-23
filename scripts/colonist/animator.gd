extends AnimatedSprite2D

class_name Animator;

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

const _threshold : float = 0.5;
var _animation : ANIMATIONS = ANIMATIONS.still :
	get: return _animation;
	set(value):
		_animation = value;
		play(ANIMATIONS.keys()[value]);
var _still_direction : ANIMATIONS = ANIMATIONS.south;

func interact() -> void:
	_animation =ANIMATIONS.interact;

const _h : float = 0.4142;
func direct(direction : Vector2) -> void:
	var pure_x : float = absf(direction.x);
	var pure_y : float = absf(direction.y);
	if (pure_x < 0.1 && pure_y < 0.1):
		_animation = ANIMATIONS.still;
		frame = _still_direction;
		return;
	if (pure_x > pure_y):
		var half : float = pure_x * _h;
		if (direction.x > 0):
			if (direction.y > half):
				_animation = ANIMATIONS.south_west;
				_still_direction = ANIMATIONS.south_west;
				return;
			if (direction.y < -half):
				_animation = ANIMATIONS.north_west;
				_still_direction = ANIMATIONS.north_west;
				return;
			_animation = ANIMATIONS.east;
			_still_direction = ANIMATIONS.east;
			return;
		else:
			if (direction.y > half):
				_animation = ANIMATIONS.south_east;
				_still_direction = ANIMATIONS.south_east;
				return;
			if (direction.y < -half):
				_animation = ANIMATIONS.north_east;
				_still_direction = ANIMATIONS.north_east;
				return;
			_animation = ANIMATIONS.west;
			_still_direction = ANIMATIONS.west;
			return;
	else:
		var half : float = pure_y * _h;
		if (direction.y > 0):
			if (direction.x > half):
				_animation = ANIMATIONS.south_east;
				_still_direction = ANIMATIONS.south_east;
				return;
			if (direction.x < -half):
				_animation = ANIMATIONS.south_west;
				_still_direction = ANIMATIONS.south_west;
				return;
			_animation = ANIMATIONS.south;
			_still_direction = ANIMATIONS.south;
			return;
		else:
			if (direction.x > half):
				_animation = ANIMATIONS.north_east;
				_still_direction = ANIMATIONS.north_east;
				return;
			if (direction.x < -half):
				_animation = ANIMATIONS.north_west;
				_still_direction = ANIMATIONS.north_west;
				return;
			_animation = ANIMATIONS.north;
			_still_direction = ANIMATIONS.north;
			return;
