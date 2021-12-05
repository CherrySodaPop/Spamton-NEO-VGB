extends Sprite

var LIFE:float = 0.0;

func _process(delta):
	LIFE += delta;
	scale += Vector2(0.1,0.1) * delta;
	modulate.a = sin(LIFE) * 0.4;
	if (LIFE >= PI):
		queue_free();
