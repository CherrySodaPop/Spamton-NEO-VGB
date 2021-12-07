extends Area2D

var lifeTime:float = 0.0;
var hasLifeTime:bool = false;
var hitCount:int = 0;
export (int) var breakCount:int = 1;
export (bool) var spitPellet:bool = false;
export (float) var spitTime:float = 0.0;
var spatPellet:bool = false;

export (Vector2) var moveDir:Vector2 = Vector2.ZERO;
onready var originalMoveDir:Vector2 = moveDir;
export (bool) var slowDown:bool = false;
var slowDownAmp:float = 1.0;
var slowDownState:bool = false;
export (bool) var requiresChargedShot:bool = false;

var sndBreak = preload("res://objects/sounds/sndProjectileBreak.tscn");
var projPellet = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonPellet.tscn");

func _ready():
	set_meta("projectileType", "ENEMY");
	set_meta("damageAmount", 20);
	if (requiresChargedShot): $AnimatedSprite.animation = "megaHead"

func _process(delta):
	
	lifeTime += delta;
	
	if (spitTime - 1.0 <= lifeTime):
		if (slowDown):
			if (!slowDownState):
				slowDownAmp = clamp(slowDownAmp - (delta), 0.0, 1.0);
			else:
				slowDownAmp = clamp(slowDownAmp + (delta), 0.0, 1.0);
			if (slowDownAmp == 0.0):
				slowDownState = !slowDownState;
			moveDir = originalMoveDir * slowDownAmp;
	
	global_transform.origin += moveDir * delta;
	
	if (spitPellet):
		if (spitTime <= lifeTime && lifeTime <= spitTime + 0.15):
			$AnimatedSprite.frame = 1;
			if (!spatPellet):
				var USERSOUL = get_tree().current_scene.get_node("USER_SOUL")
				var tmpObj = projPellet.instance();
				get_tree().current_scene.add_child(tmpObj);
				tmpObj.global_transform.origin = global_transform.origin;
				tmpObj.moveDir = (USERSOUL.global_transform.origin - global_transform.origin).normalized() * 100;
				spatPellet = true;
		else:
			$AnimatedSprite.frame = 0;
	
	if (hasLifeTime && lifeTime > 15.0): queue_free();
	
	if (hitCount >= breakCount):
		get_tree().current_scene.get_node("USER_SOUL").WAITING_FOR_USER_COUNT += 1
		get_tree().current_scene.get_node("USER_SOUL").WAITING_FOR_USER_TOTAL_COUNT += 1;
		var tmpObj = sndBreak.instance();
		get_tree().current_scene.add_child(tmpObj);
		queue_free();
