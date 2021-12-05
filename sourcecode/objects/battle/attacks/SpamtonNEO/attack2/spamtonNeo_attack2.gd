extends Node2D

var lifeTimer:float = 0.0;
var topPhoneStartPos:Vector2 = Vector2.ZERO;
var bottomPhoneStartPos:Vector2 = Vector2.ZERO;
var topJointStartPos:Vector2 = Vector2.ZERO;
var bottomJointStartPos:Vector2 = Vector2.ZERO;
var chompPrev:int = 0;

var moveSpeed:float = -13.0;

var projRing = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonRingRing.tscn");
var sndDamage = preload("res://objects/sounds/sndEnemyHurt.tscn");

func _ready():
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal").visible = false;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal/CollisionShape2D").disabled = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide").visible = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide/CollisionShape2D").disabled = false;
	
	topPhoneStartPos = $spamtonPhoneTop.transform.origin;
	bottomPhoneStartPos = $spamtonPhoneBottom.transform.origin;
	topJointStartPos = $spamtonJointTop.transform.origin;
	bottomJointStartPos = $spamtonJointBottom.transform.origin;

func _process(delta):
	lifeTimer += delta;
	
	if (lifeTimer > 8.0):
		get_tree().current_scene.ExitAttack();
		queue_free();
	
	if (chompPrev != $spamtonPhoneHead.frame):
		chompPrev = $spamtonPhoneHead.frame;
		if (chompPrev == 1):
			var tmpObj = projRing.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.global_transform.origin = $spamtonPhoneHead.transform.origin;
	
	moveSpeed = clamp(moveSpeed - (delta * 45.0),-13.0,INF);
	$spamtonPhoneHead.transform.origin.x += moveSpeed * delta;
	
	$spamtonPhoneHead.transform.origin.y = sin(lifeTimer*5) * 15.0;
	
	$spamtonJointTop4.transform.origin = (($spamtonJointTop.transform.origin - $spamtonPhoneHead.transform.origin) * 0.75) + $spamtonPhoneHead.transform.origin;
	$spamtonJointTop5.transform.origin = (($spamtonJointTop.transform.origin - $spamtonPhoneHead.transform.origin) * 0.5) + $spamtonPhoneHead.transform.origin;
	$spamtonJointTop6.transform.origin = (($spamtonJointTop.transform.origin - $spamtonPhoneHead.transform.origin) * 0.25) + $spamtonPhoneHead.transform.origin;
	$spamtonJointTop2.transform.origin = (($spamtonPhoneTop.transform.origin - $spamtonJointTop.transform.origin) * 1/3) + $spamtonJointTop.transform.origin;
	$spamtonJointTop3.transform.origin = (($spamtonPhoneTop.transform.origin - $spamtonJointTop.transform.origin) * 2/3) + $spamtonJointTop.transform.origin;
	$topWire0.points[0].x = $spamtonJointTop.transform.origin.x;
	$topWire0.points[0].y = $spamtonJointTop.transform.origin.y;
	$topWire0.points[1].x = $spamtonPhoneHead.transform.origin.x;
	$topWire0.points[1].y = $spamtonPhoneHead.transform.origin.y;
	$topWire1.points[0].x = $spamtonJointTop.transform.origin.x;
	$topWire1.points[0].y = $spamtonJointTop.transform.origin.y;
	$topWire1.points[1].x = $spamtonPhoneTop.transform.origin.x;
	$topWire1.points[1].y = $spamtonPhoneTop.transform.origin.y;
	
	$spamtonJointBottom4.transform.origin = (($spamtonJointBottom.transform.origin - $spamtonPhoneHead.transform.origin) * 0.75) + $spamtonPhoneHead.transform.origin;
	$spamtonJointBottom5.transform.origin = (($spamtonJointBottom.transform.origin - $spamtonPhoneHead.transform.origin) * 0.5) + $spamtonPhoneHead.transform.origin;
	$spamtonJointBottom6.transform.origin = (($spamtonJointBottom.transform.origin - $spamtonPhoneHead.transform.origin) * 0.25) + $spamtonPhoneHead.transform.origin;
	$spamtonJointBottom2.transform.origin = (($spamtonPhoneBottom.transform.origin - $spamtonJointBottom.transform.origin) * 1/3) + $spamtonJointBottom.transform.origin;
	$spamtonJointBottom3.transform.origin = (($spamtonPhoneBottom.transform.origin - $spamtonJointBottom.transform.origin) * 2/3) + $spamtonJointBottom.transform.origin;
	$bottomWire0.points[0].x = $spamtonJointBottom.transform.origin.x;
	$bottomWire0.points[0].y = $spamtonJointBottom.transform.origin.y;
	$bottomWire0.points[1].x = $spamtonPhoneHead.transform.origin.x;
	$bottomWire0.points[1].y = $spamtonPhoneHead.transform.origin.y;
	$bottomWire1.points[0].x = $spamtonJointBottom.transform.origin.x;
	$bottomWire1.points[0].y = $spamtonJointBottom.transform.origin.y;
	$bottomWire1.points[1].x = $spamtonPhoneBottom.transform.origin.x;
	$bottomWire1.points[1].y = $spamtonPhoneBottom.transform.origin.y;
	
	$spamtonJointBottom4.transform.origin = (($spamtonJointBottom.transform.origin - $spamtonPhoneHead.transform.origin) * 0.75) + $spamtonPhoneHead.transform.origin;
	
	var phoneAmp = 24.0;
	var JointAmp = 8.0;
	var topPhoneCalc = clamp(sin(lifeTimer * 4) * phoneAmp, 0.0, INF);
	var bottomPhoneCalc = clamp(sin(lifeTimer * 4) * phoneAmp, -INF, 0.0);
	$spamtonPhoneTop.transform.origin.y = topPhoneStartPos.y - topPhoneCalc;
	$spamtonPhoneBottom.transform.origin.y = bottomPhoneStartPos.y - bottomPhoneCalc;
	$spamtonJointTop.transform.origin.y = topJointStartPos.y - clamp(sin(lifeTimer * 4) * JointAmp, 0.0, INF);
	$spamtonJointBottom.transform.origin.y = bottomJointStartPos.y - clamp(sin(lifeTimer * 4) * JointAmp, -INF, 0.0);
	
	if (topPhoneCalc != 0.0):
		$spamtonPhoneTop.transform.origin.x += (moveSpeed * 1.75) * delta;
		$spamtonJointTop.transform.origin.x += (moveSpeed * 1.75) * delta;
	if (bottomPhoneCalc != 0.0):
		$spamtonPhoneBottom.transform.origin.x += (moveSpeed * 1.75) * delta;
		$spamtonJointBottom.transform.origin.x += (moveSpeed * 1.75) * delta;
		
	if ($spamtonPhoneHead/HitBox.prevHitCount != $spamtonPhoneHead/HitBox.hitCount):
		$spamtonPhoneHead/HitBox.prevHitCount = $spamtonPhoneHead/HitBox.hitCount;
		var tmpObj = sndDamage.instance()
		get_tree().current_scene.add_child(tmpObj);
		tmpObj.volume_db = 6;
		if (!$spamtonPhoneHead/HitBox.chargeHit):
			moveSpeed = 5.0;
		else:
			moveSpeed = 20.0;
		$spamtonPhoneHead/HitBox.chargeHit = false;
