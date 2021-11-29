extends Area2D

var hitCount:int = 0;
export (int) var breakCount:int = 1;

func _ready():
	set_meta("projectileType", "ENEMY");

func _process(delta):
	if (hitCount >= breakCount):
		queue_free();
