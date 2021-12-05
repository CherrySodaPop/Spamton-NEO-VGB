extends Area2D

var hit:bool = false;
var hitCountPrev:int = 0;
var hitCount:int = 0;

var soundDamage = preload("res://objects/sounds/sndEnemyHurt.tscn");

func _ready():
	set_meta("projectileType","ENEMY");

func _process(delta):
	if (hitCountPrev != hitCount):
		hitCountPrev = hitCount;
		var tmpObj = soundDamage.instance();
		get_tree().current_scene.add_child(tmpObj);
		tmpObj.volume_db = 6;
