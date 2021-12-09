extends Node2D

var lifeTimer:float = 0.0;
var moveDir:Vector2 = Vector2.ZERO;

func _ready():
	randomize();
	moveDir.x = rand_range(-90,90);
	moveDir.y = rand_range(-100,-60);
	var randValue = randi() % 2;
	if (randValue):
		$PIECE0.visible = true;
		$PIECE1.visible = false;
	else:
		$PIECE0.visible = false;
		$PIECE1.visible = true;

func _process(delta):
	lifeTimer += delta;
	
	moveDir.y = clamp(moveDir.y + (delta * 100), -100, 120);
	transform.origin += moveDir * delta;
	
	if (lifeTimer >= 6.0):
		queue_free();
