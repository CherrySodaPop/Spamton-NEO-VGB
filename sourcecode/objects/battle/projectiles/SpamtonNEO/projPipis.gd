extends Area2D

var specialPipis:bool = false;
var moveSpeed:Vector2 = Vector2.ZERO;
var prevHitCount:int = 0;
var hitCount:int = 0;
var lifeTimer:float = 0.0;
var bounceFactor:float = 0.0;
var chargeHit = false;

var MYHEAD = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonHead.tscn");
var sndHit = preload("res://objects/sounds/sndEnemyHurt.tscn");

func _ready():
	set_meta("projectileType", "ENEMY");
	moveSpeed.x = rand_range(-30,-10);
	moveSpeed.y = rand_range(-90,0);
	bounceFactor = rand_range(-90,-60);

func _process(delta):
	lifeTimer += delta;
	
	if (!get_tree().current_scene.battleEnemyAttacking): queue_free();
	
	$pipis.frame = clamp(hitCount,0,2);
	$pipis.rotation += deg2rad(800) * delta;
	if (lifeTimer >= 2.0):
		$specialPipis.visible = false;
	else:
		$specialPipis.visible = specialPipis;
	
	if (transform.origin.y >= 27):
		moveSpeed.y = bounceFactor;
	
	moveSpeed.y += 60 * delta;
	moveSpeed.y = clamp(moveSpeed.y,-120,120);
	
	transform.origin += moveSpeed * delta;
	
	if (prevHitCount != hitCount):
		var tmpObj = sndHit.instance();
		get_tree().current_scene.add_child(tmpObj);
		if (chargeHit): hitCount += 2;
		chargeHit = false;
		prevHitCount = hitCount;
	
	# MY [EGGS]!
	if (hitCount > 2):
		queue_free();
	
	# EXPLODE
	if (transform.origin.x <= -10):
		var tmpObj = MYHEAD.instance();
		get_tree().current_scene.add_child(tmpObj);
		var HEARTSHAPEDOBJECT = get_tree().current_scene.get_node("USER_SOUL");
		tmpObj.transform.origin = transform.origin;
		tmpObj.moveDir = (HEARTSHAPEDOBJECT.transform.origin - tmpObj.transform.origin).normalized() * 300;
		tmpObj.breakCount = 100;
		tmpObj.hasLifeTime = true;
		queue_free();
	
	# DAMN IT
	if (lifeTimer >= 10.0): queue_free();
