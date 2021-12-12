extends Node2D

var lifeTimer:float = 0.0;
var moveDir:Vector2 = Vector2.ZERO;

func _ready():
	moveDir.x = rand_range(10,50);
	moveDir.y = rand_range(-70,-90);

func _process(delta):
	lifeTimer += delta;
	transform.origin += moveDir * delta;
	modulate.a = clamp(modulate.a - delta, 0.0, 1.0);
	if (modulate.a == 0.0): queue_free();
