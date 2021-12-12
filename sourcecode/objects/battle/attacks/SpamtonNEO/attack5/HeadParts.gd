extends Area2D
var prevHitCount:int = 0;
var hitCount:int = 0;

var sndDamage = preload("res://objects/sounds/sndEnemyHurt.tscn");

func _ready():
	set_meta("projectileType", "ENEMY");

func _process(delta):
	if (prevHitCount != hitCount && hitCount < 10):
		get_tree().current_scene.add_child(sndDamage.instance());
		prevHitCount = hitCount;
