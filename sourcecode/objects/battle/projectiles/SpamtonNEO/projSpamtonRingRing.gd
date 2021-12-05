extends Area2D

var lifeTime:float = 0.0;
var ringring:bool = false;
var moveSpeed:float = -90.0;

func _ready():
	set_meta("projectileType", "ENEMY");
	set_meta("damageAmount", 20);
	set_meta("blockPellet", false);

func _process(delta):
	
	lifeTime += delta;
	
	if (lifeTime <= 0.2 || 1.0 <= lifeTime):
		global_transform.origin.x += moveSpeed * delta;
		
	if (lifeTime >= 1.0):
		$ringring.visible = false;
		$garbagenoise.visible = true;
	
	if (lifeTime > 10.0): queue_free();
