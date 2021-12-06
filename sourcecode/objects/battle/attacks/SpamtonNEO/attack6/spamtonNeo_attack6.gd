extends Node2D

var lifeTimer:float = 0.0;
var prevAimPipisState:bool = false;

var projPipisCannon = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonPipisCannon.tscn");

func _ready():
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal").visible = false;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Normal/CollisionShape2D").disabled = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide").visible = true;
	get_tree().current_scene.get_node("USER_SOUL_BOX/Wide/CollisionShape2D").disabled = false;
	get_tree().current_scene.get_node("spamtonNEO").aimPipis = true;
	get_tree().current_scene.get_node("spamtonNEO").aimPipisFire = true;

func _process(delta):
	lifeTimer += delta;
	
	var SPAMTONNEO = get_tree().current_scene.get_node("spamtonNEO");
	SPAMTONNEO.get_node("spriteJoint").transform.origin.x = (sin(lifeTimer*2) * 15) + 5
	SPAMTONNEO.get_node("spriteJoint").transform.origin.y = (sin(lifeTimer*3) * 20)
	
	if (SPAMTONNEO.aimPipisState != prevAimPipisState):
		var tmpObj = projPipisCannon.instance();
		add_child(tmpObj);
		tmpObj.global_transform.origin = SPAMTONNEO.get_node("spriteJoint/armRJoint").global_transform.origin;
		prevAimPipisState = SPAMTONNEO.aimPipisState;
