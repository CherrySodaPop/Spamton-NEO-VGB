extends Node2D

var lifeTimer:float = 0.0
var shaked:bool = false;
var kissTimer:float = 0.0;
var kissTick:float = 0.0;
var noseTimer:float = 0.0;
var noseTick:float = 0.0;
var eyeTimer:float = 0.0;
var eyeTick:float = 0.0;

var projKiss = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonKiss.tscn");
var projPellet = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonPellet.tscn");
var projNose = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonNose.tscn");

func _ready():
	pass

func _process(delta):
	lifeTimer += delta;
	
	if (lifeTimer >= 1.0):
		$spamtonBox.transform.origin.x = clamp($spamtonBox.transform.origin.x - (400 * delta), 20, INF);
	
	if ($spamtonBox.transform.origin.x == 20 && !shaked):
		Persistant.get_node("controllerCamera").shakeAmp = 3.0;
		shaked = true;
	
	if ($spamtonBox/Eyes.hitCount >= 10):
		$spamtonBox/Head/Top.frame = 1;
	if ($spamtonBox/Nose.hitCount >= 10):
		$spamtonBox/Head/Nose.visible = false;
	if ($spamtonBox/Mouth.hitCount >= 10):
		$spamtonBox/Head/Bottom.frame = 2;
	
	if ($spamtonBox/Head/Bottom.frame != 2):
		kissTimer += delta;
		if (kissTimer >= 2.0):
			$spamtonBox/Head/Bottom.frame = 1;
			kissTick += delta;
		if (kissTimer >= 3.0):
			kissTimer = 0.0;
			kissTick = 0.0;
			$spamtonBox/Head/Bottom.frame = 0;
		if (kissTick >= 0.3):
			var tmpObj = projKiss.instance();
			add_child(tmpObj);
			tmpObj.transform.origin = $spamtonBox/Head/Bottom.transform.origin + Vector2(-10,0);
			kissTick = 0.0;
	if ($spamtonBox/Head/Nose.visible):
		noseTimer += delta;
		if (noseTimer >= 5.0):
			noseTick += delta;
		if (noseTimer >= 6.0):
			noseTimer = 0.0;
			noseTick = 0.0;
		if (noseTick >= 0.3):
			var tmpObj = projNose.instance();
			add_child(tmpObj);
			tmpObj.transform.origin = $spamtonBox/Head/Nose.transform.origin + Vector2(15,0);
			
			tmpObj = projNose.instance();
			add_child(tmpObj);
			tmpObj.transform.origin = $spamtonBox/Head/Nose.transform.origin + Vector2(15,0);
			tmpObj.moveDir.y = -30;
			
			tmpObj = projNose.instance();
			add_child(tmpObj);
			tmpObj.transform.origin = $spamtonBox/Head/Nose.transform.origin + Vector2(15,0);
			tmpObj.moveDir.y = 30;
			
			noseTick = 0.0;
	if ($spamtonBox/Head/Top.frame != 1):
		eyeTimer += delta;
		if (eyeTimer >= 2.0):
			eyeTick += delta;
		if (eyeTimer >= 3.0):
			eyeTimer = 0.0;
			eyeTick = 0.0;
		if (eyeTick >= 0.1):
			var tmpObj = projPellet.instance();
			add_child(tmpObj);
			tmpObj.transform.origin = $spamtonBox/Head/Top.transform.origin + Vector2(0,0);
			var HEARTSHAPEDOBJECT = get_tree().current_scene.get_node("USER_SOUL");
			tmpObj.moveDir = (HEARTSHAPEDOBJECT.transform.origin - tmpObj.transform.origin).normalized() * 100;
			eyeTick = 0.0;
	
	if (lifeTimer > 30.0 || ($spamtonBox/Eyes.hitCount >= 10 && $spamtonBox/Mouth.hitCount >= 10 && $spamtonBox/Nose.hitCount >= 10)):
		get_tree().current_scene.ExitAttack();
		queue_free();
