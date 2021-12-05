extends Area2D

var lifeTime:float = 0.0;
var hasLifeTime:bool = false;
var hitCount:int = 0;
export (int) var breakCount:int = 1;

export (Vector2) var moveDir:Vector2 = Vector2.ZERO;
export (bool) var requiresChargedShot:bool = false;

var sndBreak = preload("res://objects/sounds/sndProjectileBreak.tscn");

func _ready():
	set_meta("projectileType", "ENEMY");
	set_meta("damageAmount", 20);
	if (requiresChargedShot): $AnimatedSprite.animation = "megaHead"

func _process(delta):
	
	lifeTime += delta;
	global_transform.origin += moveDir * delta;
	
	if (hasLifeTime && lifeTime > 10.0): queue_free();
	
	if (hitCount >= breakCount):
		get_tree().current_scene.get_node("USER_SOUL").WAITING_FOR_USER_COUNT += 1
		get_tree().current_scene.get_node("USER_SOUL").WAITING_FOR_USER_TOTAL_COUNT += 1;
		var tmpObj = sndBreak.instance();
		get_tree().current_scene.add_child(tmpObj);
		queue_free();
