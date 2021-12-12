extends Sprite

func _ready():
	pass # Replace with function body.

func _process(delta):
	scale.x = clamp(scale.x - delta, 0.0, 1.0);
	scale.y = clamp(scale.y - delta, 0.0, 1.0);
	
	if (scale.x == 0.0): queue_free();
