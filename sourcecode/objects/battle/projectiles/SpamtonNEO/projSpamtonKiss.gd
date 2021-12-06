extends Area2D

var lifeTime:float = 0.0;
var pullForce:float = 0.0;

export (Vector2) var moveDir:Vector2 = Vector2(-60,0);

func _ready():
	set_meta("projectileType", "ENEMY");
	set_meta("damageAmount", 30);
	set_meta("blockPellet", false);
	pullForce = rand_range(30,50);

func _process(delta):
	
	lifeTime += delta;
	moveDir.y -= pullForce * delta;
	global_transform.origin += moveDir * delta;
	
	if (lifeTime > 10.0): queue_free();
