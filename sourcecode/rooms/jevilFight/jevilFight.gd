extends Node2D

var lifeTimer:float = 0.0;
var honkTimer:float = 1.0;

func _ready():
	OS.set_window_title(":3c");
	$jevilSpr.modulate.a = 1.0;

func _process(delta):
	lifeTimer += delta;
	
	if (lifeTimer >= 8.0):
		$mystery.modulate.a = clamp($mystery.modulate.a + (delta / 4.0),0.0,1.0);
	
	honkTimer += delta;
	if (honkTimer < 0.1):
		$jevilSpr.scale.y = 0.75;
	else:
		$jevilSpr.scale.y = 1.0;
	
	if (Input.is_action_just_pressed("confirm")):
		$honk.playing = true;
		$jevilSpr.scale.y = 1.0;
		honkTimer = 0.0
