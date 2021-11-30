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
var battleSelectionConfirmed:bool = false;
var battleEnemyAttacking:bool = false;
var battleEnemyFiredAttack:bool = false;
var battleEnemyAttackCount:int = 0;

var spamtonAttack0 = preload("res://objects/battle/attacks/SpamtonNEO/spamtonNeo_attack0.tscn");

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
			battleShowHud = false;
			battleEnemyAttacking = true;
		
		if (battleSelectionWaitTime >= 1.2):
			$USER_SOUL.global_transform.origin = Vector2.ZERO;
			$USER_SOUL.EnableBattle();
			battleSelectionConfirmed = false;
			HandleAttack();
	
	HandleBattleVisuals(delta);

func HandleAttack():
	
	if (battleEnemyAttackCount == 0):
		var tmpScene = spamtonAttack0.instance();
		get_tree().current_scene.add_child(tmpScene);
		return;
	
	battleEnemyAttackCount += 1;

func HandleBattleHud(delta):
	if (!battleShowHud): return;
	
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
	$USER_SOUL_BOX.rotation_degrees = round(SOUL_BOX_ROTATION);
	$USER_SOUL_BOX.scale.x = clamp($USER_SOUL_BOX.scale.x, 0.0, 1.0);
	$USER_SOUL_BOX.scale.y = clamp($USER_SOUL_BOX.scale.y, 0.0, 1.0);

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
