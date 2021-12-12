extends Node2D

var lifeTimer:float = 0.0;
var rung:bool = false;
var desiredRotation:float = 110.0;
var pipisTick:float = 0.0;
var specialPipis:bool = true;
var projPipis = preload("res://objects/battle/projectiles/SpamtonNEO/projPipis.tscn");

func _ready():
	get_tree().current_scene.get_node("spamtonNEO").ringring = true;
	visible = false;

func _process(delta):
	lifeTimer += delta;
	
	if (lifeTimer >= 0.5 && !rung):
		$ringring.playing = true;
		rung = true;
	
	if (lifeTimer > 18.0):
		get_tree().current_scene.get_node("spamtonNEO").ringring = false;
		get_tree().current_scene.ExitAttack();
		queue_free();
	
	if (lifeTimer >= 5.5):
		visible = true;
		pipisTick += delta;
		$MYARM.offset.y = lerp($MYARM.offset.y, 10, 10 * delta);
		$MYARM.rotation = lerp_angle($MYARM.rotation, deg2rad(desiredRotation), 10 * delta)
		
		if (pipisTick >= 1.0):
			pipisTick = 0.0;
			$MYARM.offset.y = 0;
			desiredRotation = rand_range(110,150);
			var tmpObj = projPipis.instance();
			get_tree().current_scene.add_child(tmpObj);
			tmpObj.specialPipis = specialPipis;
			specialPipis = false;
			tmpObj.global_transform.origin = $MYARM/FIREPOINT.global_position;
