extends KinematicBody2D

var disableSoul:bool = false;
var disableMovement:bool = true;
var canShoot:bool = false;
var zapTimer:float = 0.0;
var chargeTimer:float = 0.0;

var health:int = 150;
var healthMax:int = 150;
var damaged:bool = false;
var damageMultiplier:float = 1.0;
var invisTimer:float = 0.0;
var flashTimer:float = 0.0;
var guard:bool = false;

var movementActionStrength:float = 0.2;
var speed = 60;

var startMettatonFight:bool = false
var startMettatonFightTimer:float = 0.0;

var projMettaton = preload("res://objects/battle/projectiles/USER_SOUL/projMettatonPellet.tscn");
var projMettatonCharged = preload("res://objects/battle/projectiles/USER_SOUL/projMettatonPelletCharged.tscn");

var SOUL_TURNED:bool = false;
var SOUL_SHINED:bool = false;
var SOUL_SHINE = preload("res://objects/battle/USER_SOUL/USER_SOUL_SHINE.tscn");
var WAITING_FOR_USER:bool = false;
var WAITING_FOR_USER_COUNT:int = 0;
var WAITING_FOR_USER_TOTAL_COUNT:int = 0;

func _ready():
	$HitboxCollisionSoul.connect("area_entered",self,"_TouchingArea");

func _process(delta):
	
	health = clamp(health, -INF, healthMax);
	
	if (damaged):
		if (invisTimer == 0.0): $soulHurt.playing = true;
		invisTimer += delta;
		flashTimer += delta;
	
	if (flashTimer >= 0.1):
		$spriteJoint.visible = !$spriteJoint.visible;
		flashTimer = 0.0;
	
	if (invisTimer >= 1.0):
		damaged = false;
		invisTimer = 0.0;
		$spriteJoint.visible = true;
		flashTimer = 0.0;
	
	if (!disableSoul):
		HandleMovement(delta);
	HandleShooting(delta);
		
	HandleMettatonFight(delta);
	
	WAITING_FOR_USER(delta);

func HandleMovement(delta):
	var vecVelocity:Vector2 = Vector2.ZERO;
	
	if (!disableMovement):
		if (Input.get_action_strength("moveUp") > movementActionStrength):
			vecVelocity += Vector2(0,-speed);
		
		if (Input.get_action_strength("moveDown") > movementActionStrength):
			vecVelocity += Vector2(0,speed);
		
		if (Input.get_action_strength("moveLeft") > movementActionStrength):
			vecVelocity += Vector2(-speed,0);
			
		if (Input.get_action_strength("moveRight") > movementActionStrength):
			vecVelocity += Vector2(speed,0);
			
	move_and_slide(vecVelocity);

func HandleShooting(delta):
	zapTimer += delta;
	$soulCharge.pitch_scale = clamp((chargeTimer - 0.1) / 0.4, 0.01, 1.0);
	
	$spriteJoint/glow.scale.x = (abs(sin(chargeTimer * 10.0) * 3)) * clamp(chargeTimer,0.0,1.0);
	$spriteJoint/glow.scale.y = (abs(sin(chargeTimer * 10.0) * 3)) * clamp(chargeTimer,0.0,1.0);
	
	if ($soulCharge.pitch_scale <= 0.01):
		$soulCharge.volume_db = -80.0;
	else:
		$soulCharge.volume_db = 0;
	
	if (canShoot && !disableSoul):
		if (Input.is_action_pressed("zapKey")):
			chargeTimer += delta;
		
		if (Input.is_action_just_released("zapKey")):
			# default shooting
			if (zapTimer >= 0.1 && chargeTimer <= 0.5):
				var tmpObj = projMettaton.instance();
				get_tree().current_scene.add_child(tmpObj);
				tmpObj.global_transform.origin = global_transform.origin + Vector2(4,0);
				tmpObj.z_index = z_index;
				zapTimer = 0.0;
			
			# charged shot
			if (chargeTimer > 0.5):
				var tmpObj = projMettatonCharged.instance();
				get_tree().current_scene.add_child(tmpObj);
				tmpObj.global_transform.origin = global_transform.origin + Vector2(4,0);
				tmpObj.z_index = z_index;
			
			if (!Input.is_action_pressed("zapKeyBroken")): chargeTimer = 0.0;
		
		if (Input.is_action_just_pressed("zapKeyBroken") && chargeTimer > 0.5):
			# HEY QUIT THAT!
			var tmpObj = projMettatonCharged.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.global_transform.origin = global_transform.origin + Vector2(4,0);
			tmpObj.z_index = z_index;
	else:
		chargeTimer = 0.0;

func EnableBattle():
	disableSoul = false;
	disableMovement = false;
	visible = true;

func DisableBattle():
	disableSoul = true;
	disableMovement = true;
	visible = false;
	guard = false;

func HandleMettatonFight(delta):
	if (startMettatonFight):
		if (!SOUL_TURNED):
			$soulTurn.playing = true;
			SOUL_TURNED = true;
		$spriteJoint.rotation = lerp($spriteJoint.rotation,deg2rad(-90),0.5);
		startMettatonFightTimer += delta;
		
	if (startMettatonFightTimer > 1.5):
		if (!SOUL_SHINED):
			Persistant.get_node("controllerCamera").shakeAmp = 3.0;
			$soulShine.playing = true;
			add_child(SOUL_SHINE.instance());
			SOUL_SHINED = true;
		$spriteJoint/sprite.animation = "SOUL_METTATON";

func AlphysPhoneCallActivate():
	startMettatonFight = true;

func _TouchingArea(area:Area2D):
	if (disableSoul): return;
	
	if (area && area.has_meta("projectileType") && area.get_meta("projectileType") == "ENEMY"):
		if (!damaged):
			if (area.has_meta("damageAmount")):
				health -= int((area.get_meta("damageAmount") * damageMultiplier) / ( 1.0 + float(guard)) );
			Persistant.get_node("controllerCamera").shakeAmp = 2.0;
			damaged = true;

func WAIT_FOR_USER():
	canShoot = true;
	get_tree().current_scene.get_node("AnimationPlayer").stop(false);
	WAITING_FOR_USER = true;

func WAITING_FOR_USER(delta):
	if (WAITING_FOR_USER):
		if (WAITING_FOR_USER_COUNT == 4 && WAITING_FOR_USER_TOTAL_COUNT <= 8):
			canShoot = false;
			get_tree().current_scene.get_node("AnimationPlayer").play("intro");
			WAITING_FOR_USER = false;
			WAITING_FOR_USER_COUNT = 0;
		if (!get_tree().current_scene.get_node("AnimationPlayer").is_playing() && WAITING_FOR_USER_TOTAL_COUNT == 13):
			WAITING_FOR_USER = false;
			get_tree().current_scene.get_node("spamtonNEO").aimPipis = false;
			get_tree().current_scene.get_node("spamtonLaugh").playing = true;
			get_tree().current_scene.get_node("AnimationPlayer").seek(0.0);
			get_tree().current_scene.get_node("AnimationPlayer").play("beginFight");
			canShoot = true;
			disableSoul = true;
