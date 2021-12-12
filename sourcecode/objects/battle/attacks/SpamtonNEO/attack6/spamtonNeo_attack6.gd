extends Node2D

var lifeTimer:float = 0.0;
var fireCannon:bool = false;
var prevAimPipisState:bool = false;

var projPipisCannon = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonPipisCannon.tscn");
var sndBigShot = preload("res://objects/sounds/sndBigShot.tscn")

func _ready():
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal").visible = false;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal/CollisionShape2D").disabled = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide").visible = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide/CollisionShape2D").disabled = false;
	
	if (fireCannon):
		get_tree().current_scene.get_node("spamtonNEO").aimPipis = true;
		get_tree().current_scene.get_node("spamtonNEO").aimPipisFire = true;

func _process(delta):
	lifeTimer += delta;
	
	var SPAMTONNEO = get_tree().current_scene.get_node("spamtonNEO");
	var USERSOUL = get_tree().current_scene.get_node("USER_SOUL")
	
	if (fireCannon):
		if (lifeTimer < 6.0):
			SPAMTONNEO.get_node("spriteJoint").transform.origin.x = (sin(lifeTimer*2) * 15) + 5
			SPAMTONNEO.get_node("spriteJoint").transform.origin.y = (sin(lifeTimer*3) * 20)
		if (SPAMTONNEO.aimPipisState != prevAimPipisState):
			var tmpObj = sndBigShot.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj = projPipisCannon.instance();
			add_child(tmpObj);
			tmpObj.global_transform.origin = SPAMTONNEO.get_node("spriteJoint/armRJoint").global_transform.origin;
			tmpObj.moveDir = (USERSOUL.global_transform.origin - SPAMTONNEO.get_node("spriteJoint/armRJoint").global_transform.origin).normalized() * 80;
			prevAimPipisState = SPAMTONNEO.aimPipisState;
		if (lifeTimer >= 6.0):
			SPAMTONNEO.get_node("spriteJoint").transform.origin = lerp(SPAMTONNEO.get_node("spriteJoint").transform.origin, Vector2.ZERO, 2.0 * delta);
	
	if (lifeTimer >= 7.0):
		get_tree().current_scene.get_node("spamtonNEO").aimPipis = false;
		get_tree().current_scene.get_node("spamtonNEO").aimPipisFire = false;
		get_tree().current_scene.ExitAttack();
		queue_free();
