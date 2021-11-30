extends Node2D

var TURN_IT_UP_BABY:bool = false;
var TURN_IT_UP_BABY_AMP:float = 0.0;

var SOUL_BOX_ROTATION:float = 0.0;

var battleReady:bool = false;
var battleShowHud:bool = false;
var battleEnemyAttacking:bool = true;
var battleEnemyFiredAttack:bool = false;

var spamtonAttack0 = preload("res://objects/battle/attacks/SpamtonNEO/spamtonNeo_attack0.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("intro")

func _process(delta):
	RIDE_AROUND_TOWN(delta);
	HandleBattle(delta);

func HandleBattle(delta):
	if (!battleReady): pass;
	
	if (battleShowHud):
		pass
	
	if (battleEnemyAttacking):
		SOUL_BOX_ROTATION = rad2deg(lerp_angle(deg2rad(SOUL_BOX_ROTATION),0, 7 * delta));
		$USER_SOUL_BOX.scale = $USER_SOUL_BOX.scale + (Vector2(1,1) * delta);
	else:
		SOUL_BOX_ROTATION = rad2deg(lerp_angle(deg2rad(SOUL_BOX_ROTATION),PI, 4 * delta));
		$USER_SOUL_BOX.scale = $USER_SOUL_BOX.scale - (Vector2(1,1) * delta);
	
	print(SOUL_BOX_ROTATION);
	
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
