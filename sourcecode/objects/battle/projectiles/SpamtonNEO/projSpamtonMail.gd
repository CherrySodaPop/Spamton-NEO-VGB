extends Area2D

var lifeTime:float = 0.0;
var hitCount:int = 0;
export (int) var breakCount:int = 1;

export (Vector2) var moveDir:Vector2 = Vector2.ZERO;
export (bool) var requiresChargedShot:bool = false;

func _ready():
	set_meta("projectileType", "ENEMY");
	set_meta("damageAmount", 30);
	set_meta("destroyBigShot", true);

func _process(delta):
	
	lifeTime += delta;
	global_transform.origin += moveDir * delta;
	
	if (lifeTime > 10.0): queue_free();
