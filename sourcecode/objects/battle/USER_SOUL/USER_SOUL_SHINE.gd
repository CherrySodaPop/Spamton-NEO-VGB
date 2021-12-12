extends Node2D

func _process(delta):
	scale.x += delta * 15.0;
	scale.y += delta * 15.0;
	modulate.a = clamp(modulate.a - (delta * 2.0),0.0,1.0);
	if (modulate.a == 0.0):
		queue_free();
