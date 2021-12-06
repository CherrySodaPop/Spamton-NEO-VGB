extends Area2D

var lifeTime:float = 0.0;

export (Vector2) var moveDir:Vector2 = Vector2(-60,0);

func _ready():
	set_meta("projectileType", "ENEMY");
	set_meta("damageAmount", 30);
	set_meta("blockPellet", false);

func _process(delta):
	lifeTime += delta;
	moveDir.y = lerp(moveDir.y, 0, delta);
	global_transform.origin += moveDir * delta;
	
	if (lifeTime > 10.0): queue_free();
