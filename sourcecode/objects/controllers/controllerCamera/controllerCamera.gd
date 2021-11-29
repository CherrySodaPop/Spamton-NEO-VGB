extends Camera2D

var infTimer:float = 0.0;
var shakeAmp:float = 0.0;

func _ready():
	pass

func _process(delta):
	infTimer += delta;
	shakeAmp = clamp(shakeAmp - (delta * 30), 0.0, INF);
	
	global_transform.origin = Vector2.ZERO;
	global_transform.origin.y = sin(infTimer*3) * shakeAmp * 6;
