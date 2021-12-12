extends Node2D

var lifeTimer:float = 0.0
var wreckTimer:float = 0.0;
var spewTimer:float = 0.0;
var spewHeadTimer:float = 0.0;
var spewHeadSwitch:bool = false;
var spewed:bool = false;
var spewedCount:int = 0;
var toggleWalk:bool = false;
var moveSpeed:float = 0.0;
var kromerTick:float = 0.0;
var dustTick:float = 0.0;
var bigshot:bool = false;
var bigshotFired:bool = false;
var bigshotTimer:float = 0.0;
var bigshotExplode:bool = false;
onready var originalBigShotPos = $BIGSHOT.transform.origin;

var projKromer = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonKromer.tscn");
var projSmallShot = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonSmallShot.tscn")
var projBigShot = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonBigShot.tscn")
var sndDamage = preload("res://objects/sounds/sndEnemyHurt.tscn");

func _ready():
	$USER_SOUL_BOX.scale = Vector2.ZERO;
	$BIGSHOT/head.modulate.a = 0.0;
	$BIGSHOT/normal.modulate.a = 0.0;
	$BIGSHOT/head.visible = true;
	$BIGSHOT/normal.visible = true;
	$BIGSHOT/HitBox/CollisionShape2D.disabled = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX").z_index = 2;
	get_tree().current_scene.get_node("USER_SOUL").z_index = 2;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal").visible = false;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal/CollisionShape2D").disabled = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide").visible = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide/CollisionShape2D").disabled = false;

func _process(delta):
	var maxHitCount:int = 40;
	lifeTimer += delta;
	$USER_SOUL_BOX.scale += Vector2(2 * delta,2 * delta);
	$USER_SOUL_BOX.rotation += deg2rad(360 * delta);
	
	if (4.0 >= lifeTimer && lifeTimer >= 2.0):
		$BIGSHOT.transform.origin.x = lerp($BIGSHOT.transform.origin.x, 70.0, 2 * delta);
	
	if (3.5 <= lifeTimer):
		$BIGSHOT/head.modulate.a = clamp($BIGSHOT/head.modulate.a + delta, 0.0, 1.0);
		$BIGSHOT/normal.modulate.a = clamp($BIGSHOT/normal.modulate.a + delta, 0.0, 1.0);
		if ($BIGSHOT/HitBox.hitCount < maxHitCount): $BIGSHOT.transform.origin.y = originalBigShotPos.y + -abs(sin(wreckTimer * 3.0) * 6);
	
	if (4.0 <= lifeTimer && wreckTimer == 0.0):
		toggleWalk = true;
		$BIGSHOT/loom.visible = false;
	
	if (toggleWalk):
		$WRECK.visible = true;
		$SPEW.visible = false;
		wreckTimer += delta;
		kromerTick += delta;
		dustTick += delta;
		if (kromerTick >= 0.4):
			kromerTick = 0.0;
			var tmpObj = projKromer.instance();
			add_child(tmpObj);
			tmpObj.transform.origin = Vector2(-80,rand_range(-50,50));
			tmpObj.z_index = 1;
		if (dustTick >= 0.1):
			dustTick = 0.0;
			var tmpObj = projKromer.instance();
			add_child(tmpObj);
			tmpObj.global_transform.origin = Vector2($BIGSHOT/head.global_transform.origin.x - 60,rand_range(-20,20));
			tmpObj.z_index = 1;
			tmpObj.moveAmp = 60;
			tmpObj.nonKromer = true;
		
		var HEARTSHAPEDOBJECT = get_tree().current_scene.get_node("USER_SOUL");
		var moveVector:Vector2 = ($BIGSHOT/head.global_transform.origin - HEARTSHAPEDOBJECT.transform.origin).normalized() * 45;
		HEARTSHAPEDOBJECT.move_and_slide(moveVector);
		
		if (0.5 <= wreckTimer):
			$BIGSHOT/head/default.visible = false;
			$BIGSHOT/head/wreck.visible = true;
			$BIGSHOT/HitBox/CollisionShape2D.disabled = false;
			moveSpeed += -20 * delta;
		
		if ($BIGSHOT/HitBox.prevHitCount != $BIGSHOT/HitBox.hitCount):
			$BIGSHOT/HitBox.prevHitCount = $BIGSHOT/HitBox.hitCount;
			moveSpeed = -5;
			var tmpObj = sndDamage.instance()
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.volume_db = 6;
		
		if ($BIGSHOT/HitBox.hitCount >= maxHitCount):
			toggleWalk = false;
		
		moveSpeed = clamp(moveSpeed,-15,15);
		$BIGSHOT.transform.origin.x += moveSpeed * delta;
	elif ($BIGSHOT/HitBox.hitCount >= maxHitCount):
		$WRECK.visible = false;
		$SPEW.visible = true;
		spewTimer += delta;
		$BIGSHOT.transform.origin.x = lerp($BIGSHOT.transform.origin.x, 70.0, 2 * delta);
		$BIGSHOT/head/default.visible = true;
		$BIGSHOT/head/wreck.visible = false;
		
		if (spewTimer <= 1.75):
			$BIGSHOT/head.rotation = lerp_angle($BIGSHOT/head.rotation, deg2rad(-9), 20 * delta);
		
		if (1.75 < spewTimer && spewTimer <= 2.5):
			$BIGSHOT/head.rotation = lerp_angle($BIGSHOT/head.rotation, deg2rad(0), 20 * delta);
		
		if (2.5 < spewTimer && spewTimer <= 3.0):
			$BIGSHOT/head.visible = false;
			$BIGSHOT/headSpew.visible = true;
		
		if (2.5 < spewTimer):
			if (!bigshot):
				spewHeadTimer += delta * 1;
				if (spewedCount >= 10): bigshot = true;
				if (spewHeadTimer >= PI/10):
					if (spewHeadTimer >= (3*PI)/20 && !spewed):
						var tmpObj = projSmallShot.instance();
						add_child(tmpObj);
						tmpObj.z_index = 2;
						tmpObj.transform.origin = $BIGSHOT/headSpew/top.global_transform.origin - Vector2(0,-10);
						spewedCount += 1;
						spewed = true;
					if (spewHeadTimer >= (PI)/5):
						spewHeadTimer = 0.0;
						spewHeadSwitch = !spewHeadSwitch;
						spewed = false;
					$BIGSHOT/headSpew/top.transform.origin.y = -abs(sin(spewHeadTimer * 10) * 12.0);
					$BIGSHOT/headSpew/bottom.transform.origin.y = abs(sin(spewHeadTimer * 10) * 12.0);
				
				if (spewHeadSwitch):
					$BIGSHOT.transform.origin.y = lerp($BIGSHOT.transform.origin.y, -8, 5 * delta);
				else:
					$BIGSHOT.transform.origin.y = lerp($BIGSHOT.transform.origin.y, 13, 5 * delta);
			else:
				$BIGSHOT.transform.origin.x = (70 + rand_range(-1,1));
				$BIGSHOT.transform.origin.y = lerp($BIGSHOT.transform.origin.y, 3 + rand_range(-5,5), 20 * delta);
				$BIGSHOT/headSpew/top.transform.origin.y = -10 + sin(lifeTimer * 30) * 3;
				$BIGSHOT/headSpew/bottom.transform.origin.y = 10 - sin(lifeTimer * 30) * 3;
				
				if (!bigshotFired): bigshotTimer += delta;
				
				if (bigshotTimer > 0.25 && !bigshotFired):
					bigshotTimer = 0.0;
					bigshotFired = true;
					var tmpObj = projBigShot.instance();
					add_child(tmpObj);
					tmpObj.z_index = 2;
					tmpObj.transform.origin = $BIGSHOT/headSpew/top.global_transform.origin + Vector2(0,2);
		
		if (bigshotExplode):
			if (bigshotTimer == 0.0): $explosion.playing = true;
			bigshotTimer += delta;
			var overlay = get_tree().current_scene.get_node("world/OverlayBright");
			overlay.modulate.a = clamp(overlay.modulate.a + (delta * 5.0), 0.0, 1.0);
			
			if (bigshotTimer >= 2.0 && overlay.modulate.a == 1.0):
				get_tree().current_scene.ExitAttack();
				get_tree().current_scene.get_node("USER_SOUL_BOX").z_index = 0;
				get_tree().current_scene.get_node("USER_SOUL").z_index = 0;
				queue_free();
