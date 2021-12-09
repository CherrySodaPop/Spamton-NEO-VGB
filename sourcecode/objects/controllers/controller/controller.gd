extends Node

var TURN_IT_UP_BABY:bool = false;
var TURN_IT_UP_BABY_AMP:float = 0.0;
var USER_SOUL_POS:Vector2 = Vector2.ZERO;

func _ready():
	pass

func _process(delta):
	if (Input.is_action_just_pressed("fullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen;
		OS.window_size = Vector2(170*3,96*3);
