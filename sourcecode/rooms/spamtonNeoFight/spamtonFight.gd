extends Node2D

var TURN_IT_UP_BABY:bool = false;
var TURN_IT_UP_BABY_AMP:float = 0.0;

var spamtonAttack0 = preload("res://objects/battle/attacks/SpamtonNEO/spamtonNeo_attack0.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("intro")

func ShakeCamera():
	Persistant.get_node("controllerCamera").shakeAmp = 3.0;

func SHOW_ON_THE_RAIL():
	TURN_IT_UP_BABY = !TURN_IT_UP_BABY;

func _process(delta):
	if (TURN_IT_UP_BABY):
		TURN_IT_UP_BABY_AMP = clamp(TURN_IT_UP_BABY_AMP + delta,0.0,3.0);
	else:
		TURN_IT_UP_BABY_AMP = clamp(TURN_IT_UP_BABY_AMP - delta,0.0,3.0);
	
	$world/rails/railKris.material.set("shader_param/speedAmp",TURN_IT_UP_BABY_AMP);
	$world/rails/railSusie.material.set("shader_param/speedAmp",TURN_IT_UP_BABY_AMP);
	$world/rails/railRalsei.material.set("shader_param/speedAmp",TURN_IT_UP_BABY_AMP);
