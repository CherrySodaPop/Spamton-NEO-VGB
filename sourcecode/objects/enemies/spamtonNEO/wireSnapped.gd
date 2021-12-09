extends Line2D

func _ready():
	pass

func _process(delta):
	points[1].y = lerp(points[1].y, 0, delta * 1.5);
	modulate.a = clamp(modulate.a - delta, 0.0, 1.0);
