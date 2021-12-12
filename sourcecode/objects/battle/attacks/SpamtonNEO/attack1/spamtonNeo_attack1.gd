extends Node2D

var lifeTimer:float = 0.0;
var fireProjectile:bool = false;
var fireProjectileWaitTimer:float = 0.0;

var invisTimer:float = 0.0;
var flashTimer:float = 0.0;

var pellet = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonPellet.tscn")

func _ready():
	get_tree().current_scene.get_node("spamtonNEO").chainedHeart = true;

func _process(delta):
	lifeTimer += delta;
	var spamtonNEO = get_tree().current_scene.get_node("spamtonNEO");
	
	HandleVisualHeart(delta);
	
	if ($chainedHeartHitbox.hitCount >= 40):
		get_tree().current_scene.get_node("spamtonNEO").chainedHeart = false;
		get_tree().current_scene.get_node("spamtonNEO").chainedHeartSpringAmp = 1.0;
		get_tree().current_scene.get_node("spamtonNEO/spriteJoint/chainedHeart/heart").visible = true;
		get_tree().current_scene.ExitAttack();
		queue_free();
	
	$chainedHeartHitbox.global_transform.origin = spamtonNEO.get_node("spriteJoint/chainedHeart/heart").global_transform.origin;
	
	if (spamtonNEO.chainedHeartBounceDir == 1):
		if (spamtonNEO.chainedHeartSpringTimer >= 0.2):
			fireProjectile = true;
	else:
		fireProjectile = false;
		fireProjectileWaitTimer = 0.0;
	
	if (fireProjectile):
		fireProjectileWaitTimer += delta
		if (fireProjectileWaitTimer >= 0.2):
			var tmpObj = null;
			
			tmpObj = pellet.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.moveDir = Vector2(-30,-30);
			tmpObj.global_transform.origin = spamtonNEO.get_node("spriteJoint/chainedHeart/heart").global_transform.origin;
			
			tmpObj = pellet.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.moveDir = Vector2(-60,0);
			tmpObj.global_transform.origin = spamtonNEO.get_node("spriteJoint/chainedHeart/heart").global_transform.origin;
			
			tmpObj = pellet.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.moveDir = Vector2(-30,30);
			tmpObj.global_transform.origin = spamtonNEO.get_node("spriteJoint/chainedHeart/heart").global_transform.origin;
			
			tmpObj = pellet.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.moveDir = Vector2(-55.65,22.429);
			tmpObj.global_transform.origin = spamtonNEO.get_node("spriteJoint/chainedHeart/heart").global_transform.origin;
			
			tmpObj = pellet.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.moveDir = Vector2(-55.65,-22.429);
			tmpObj.global_transform.origin = spamtonNEO.get_node("spriteJoint/chainedHeart/heart").global_transform.origin;
			
			fireProjectileWaitTimer = 0.0;

func HandleVisualHeart(delta):
	var chainHeart = get_tree().current_scene.get_node("spamtonNEO/spriteJoint/chainedHeart/heart");
	
	if ($chainedHeartHitbox.hit):
		invisTimer += delta;
		flashTimer += delta;
	
	if (flashTimer >= 0.06):
		chainHeart.visible = !chainHeart.visible;
		flashTimer = 0.0;
	
	if (invisTimer >= 1.0):
		$chainedHeartHitbox.hit = false;
		invisTimer = 0.0;
		chainHeart.visible = true;
		flashTimer = 0.0;
