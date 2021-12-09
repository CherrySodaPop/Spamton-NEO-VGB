extends Node2D

var TURN_IT_UP_BABY:bool = false;
var TURN_IT_UP_BABY_AMP:float = 0.0;

var SOUL_BOX_ROTATION:float = 0.0;

var battleDamage:int = 200;
var battleWireDamage:int = 6;
var battleDamageRandomRange:int = 100;
var battleReady:bool = false;
var battleShowHud:bool = true;
var battleSelectionHud:int = 0;
var battleSelectionWaitTime:float = 0.0;
var battleInputWaitTimeHud:float = 0.0;
var battleSelectionConfirmed:bool = false;
var battleEnemyAttacking:bool = false;
var battleEnemyFiredAttack:bool = false;
var battleEnemyAttackCount:int = 0;
var battleIncreaseDifficulty:bool = false;
var battleSpecialAttack:bool = false;

var spamtonAttack0 = preload("res://objects/battle/attacks/SpamtonNEO/attack0/spamtonNeo_attack0.tscn");
var spamtonAttack1 = preload("res://objects/battle/attacks/SpamtonNEO/attack1/spamtonNeo_attack1.tscn");
var spamtonAttack2 = preload("res://objects/battle/attacks/SpamtonNEO/attack2/spamtonNeo_attack2.tscn");
var spamtonAttack3 = preload("res://objects/battle/attacks/SpamtonNEO/attack3/spamtonNeo_attack3.tscn");
var spamtonAttack4 = preload("res://objects/battle/attacks/SpamtonNEO/attack4/spamtonNeo_attack4.tscn");
var spamtonAttack5 = preload("res://objects/battle/attacks/SpamtonNEO/attack5/spamtonNeo_attack5.tscn");
var spamtonAttack6 = preload("res://objects/battle/attacks/SpamtonNEO/attack6/spamtonNeo_attack6.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("intro")

func _process(delta):
	RIDE_AROUND_TOWN(delta);
	HandleBattle(delta);

func HandleBattle(delta):
	if (!battleReady): return;
	
	HandleBattleHud(delta);
	
	if (battleSelectionConfirmed):
		battleSelectionWaitTime += delta;
		
		if (battleSelectionWaitTime >= 1.0):
			if (!battleEnemyAttacking): HandleAttack();
			battleShowHud = false;
			battleEnemyAttacking = true;
		
		if (battleSelectionWaitTime >= 1.2):
			$USER_SOUL.global_transform.origin = Vector2(-44,0);
			$USER_SOUL.EnableBattle();
			battleSelectionConfirmed = false;
			battleSelectionWaitTime = 0.0;
			battleEnemyAttackCount += 1;
	
	HandleBattleVisuals(delta);

func HandleAttack():
	if (!battleSpecialAttack && $spamtonNEO.health <= 1000):
		battleEnemyAttackCount = 6;
		battleIncreaseDifficulty = true;
		battleSpecialAttack = true;
	
	if (battleEnemyAttackCount == 0):
		var tmpScene = spamtonAttack6.instance();
		if (battleIncreaseDifficulty):
			tmpScene.fireCannon = true;
		get_tree().current_scene.add_child(tmpScene);
		return;
	if (battleEnemyAttackCount == 1):
		var tmpScene = spamtonAttack0.instance();
		get_tree().current_scene.add_child(tmpScene);
		return;
	if (battleEnemyAttackCount == 2):
		var tmpScene = spamtonAttack1.instance();
		get_tree().current_scene.add_child(tmpScene);
		return;
	if (battleEnemyAttackCount == 3):
		var tmpScene = spamtonAttack2.instance();
		get_tree().current_scene.add_child(tmpScene);
		return;
	if (battleEnemyAttackCount == 4):
		var tmpScene = spamtonAttack5.instance();
		get_tree().current_scene.add_child(tmpScene);
		return;
	if (battleEnemyAttackCount == 5):
		var tmpScene = spamtonAttack3.instance();
		get_tree().current_scene.add_child(tmpScene);
		battleIncreaseDifficulty = true;
		battleEnemyAttackCount = -1;
		return;
	if (battleSpecialAttack && battleEnemyAttackCount == 6):
		var tmpScene = spamtonAttack4.instance();
		get_tree().current_scene.add_child(tmpScene);
		battleEnemyAttackCount = -1;
		return;

func HandleBattleHud(delta):
	if (!battleShowHud):
		battleInputWaitTimeHud = 0.0;
		return;
	
	battleInputWaitTimeHud += delta;
	
	if (battleInputWaitTimeHud < 0.75): return;
	
	if (battleSelectionConfirmed): return;
	
	if (Input.is_action_just_pressed("moveLeft")):
		battleSelectionHud -= 1;
	if (Input.is_action_just_pressed("moveRight")):
		battleSelectionHud += 1;
	battleSelectionHud = clamp(battleSelectionHud,0,2);
	
	if (Input.is_action_just_pressed("confirm")):
		if (battleSelectionHud == 0):
			$spamtonNEO.wireHealth -= battleWireDamage;
		if (battleSelectionHud == 1):
			$spamtonNEO.health -= battleDamage + int(rand_range(-battleDamageRandomRange/2,battleDamageRandomRange/2));
		if (battleSelectionHud == 2):
			$USER_SOUL.damageMultiplier = 0.5;
		
		battleSelectionConfirmed = true;

func HandleBattleVisuals(delta):
	# battle hud
	if (battleShowHud):
		$BattleHud.global_transform.origin.y += (48 - $BattleHud.global_transform.origin.y) * (15 * delta);
	else:
		$BattleHud.global_transform.origin.y += (68 - $BattleHud.global_transform.origin.y) * (15 * delta);
	
	$HealthHud/Line2D.points[1].x = -81 + (float($USER_SOUL.health) / float($USER_SOUL.healthMax)) * 54;
	
	$BattleHud/snap.frame = (battleShowHud && battleSelectionHud == 0);
	$BattleHud/fight.frame = (battleShowHud && battleSelectionHud == 1);
	$BattleHud/guard.frame = (battleShowHud && battleSelectionHud == 2);
	
	# the box thingy
	if (battleEnemyAttacking):
		SOUL_BOX_ROTATION = rad2deg(lerp_angle(deg2rad(SOUL_BOX_ROTATION),0, 10 * delta));
		$USER_SOUL_BOX.scale = $USER_SOUL_BOX.scale + (Vector2(2,2) * delta);
	else:
		SOUL_BOX_ROTATION = rad2deg(lerp_angle(deg2rad(SOUL_BOX_ROTATION),PI, 8 * delta));
		$USER_SOUL_BOX.scale = $USER_SOUL_BOX.scale - (Vector2(2,2) * delta);
		
		if ($USER_SOUL_BOX.scale.x < 0.1):
			$USER_SOUL_BOX/Normal.visible = true;
			$USER_SOUL_BOX/Normal/CollisionShape2D.disabled = false;
			$USER_SOUL_BOX/Wide.visible = false;
			$USER_SOUL_BOX/Wide/CollisionShape2D.disabled = true;
		
		$world/OverlayBright.modulate.a = $world/OverlayBright.modulate.a - (delta * 2.0);
		
	$USER_SOUL_BOX.rotation_degrees = round(SOUL_BOX_ROTATION);
	$USER_SOUL_BOX.scale.x = clamp($USER_SOUL_BOX.scale.x, 0.0, 1.0);
	$USER_SOUL_BOX.scale.y = clamp($USER_SOUL_BOX.scale.y, 0.0, 1.0);

func ExitAttack():
	battleShowHud = true;
	battleEnemyAttacking = false;
	$USER_SOUL.DisableBattle();

func RIDE_AROUND_TOWN(delta):
	if (TURN_IT_UP_BABY):
		TURN_IT_UP_BABY_AMP = clamp(TURN_IT_UP_BABY_AMP + delta,0.0,3.0);
	else:
		TURN_IT_UP_BABY_AMP = clamp(TURN_IT_UP_BABY_AMP - delta,0.0,3.0);
	
	$world/rails/railKris.material.set("shader_param/speedAmp",TURN_IT_UP_BABY_AMP);
	$world/rails/railSusie.material.set("shader_param/speedAmp",TURN_IT_UP_BABY_AMP);
	$world/rails/railRalsei.material.set("shader_param/speedAmp",TURN_IT_UP_BABY_AMP);

func ShakeCamera():
	Persistant.get_node("controllerCamera").shakeAmp = 3.0;

func SHOW_ON_THE_RAIL():
	TURN_IT_UP_BABY = !TURN_IT_UP_BABY;

func PULL_THE_STRINGS():
	battleReady = !battleReady;
	$bigshot.playing = true;
