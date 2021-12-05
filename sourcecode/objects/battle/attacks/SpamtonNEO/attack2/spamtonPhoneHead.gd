extends Area2D

var hit:bool = false;
var prevHitCount:int = 0;
var hitCount:int = 0;
var chargeHit:bool = false;

func _ready():
	set_meta("projectileType","ENEMY");

func _process(delta):
	pass
